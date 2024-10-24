terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.7.0"
    }
  }
}

data "google_client_config" "default" {}


# provider "kubernetes" {
#   host                   = "https://${google_container_cluster.primary.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
# }

module "cloud_sql" {
  source      = "../cloud-sql"
  project_id  = var.project_id
  db_password = var.db_password
}


resource "kubernetes_deployment_v1" "backend" {
  metadata {
    name      = "resume-backend"
    namespace = "resume-app"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "resume-backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "resume-backend"
        }
      }
      spec {
        service_account_name = "backend-service-account"
        container {
          image = "us-central1-docker.pkg.dev/${var.project_id}/portfolio-app-images/resume-backend:latest"
          name  = "resume-backend"
          port {
            container_port = 8000
          }
          env {
            name  = "ALLOWED_ORIGINS"
            value = "jaromero.cloud"
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = 8000
            }
            initial_delay_seconds = 30
            timeout_seconds       = 1
          }
          readiness_probe {
            http_get {
              path = "/readyz"
              port = 8000
            }
            initial_delay_seconds = 30
            timeout_seconds       = 1
          }
        }

        # Cloud SQL Proxy Sidecar
        container {
          name  = "cloudsql-proxy"
          image = "gcr.io/cloudsql-docker/gce-proxy:1.34.0"
          command = ["/cloud_sql_proxy",
            "-instances=${module.cloud_sql.instance_connection_name}=tcp:3306",
          "-credential_file=/secrets/cloudsql/credentials.json"]
          volume_mount {
            name       = "cloudsql-instance-credentials"
            mount_path = "/secrets/cloudsql"
            read_only  = true
          }
        }

        volume {
          name = "cloudsql-instance-credentials"
          secret {
            secret_name = "cloudsql-instance-credentials"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "backend" {
  metadata {
    name      = "resume-backend-svc"
    namespace = "resume-app"
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.backend.spec[0].selector[0].match_labels.app
    }
    port {
      name        = "api-port"
      port        = 8000
      target_port = 8000
    }
  }
}

resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name      = "resume-frontend"
    namespace = "resume-app"
    labels = {
      job  = "astro-web"
      app  = "resume-frontend"
      tier = "frontend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "resume-frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "resume-frontend"
        }
      }
      spec {
        container {
          image = "us-central1-docker.pkg.dev/${var.project_id}/portfolio-app-images/resume-frontend:latest"
          name  = "resume-frontend"
          port {
            container_port = 8080
            name           = "web-port"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "frontend" {
  metadata {
    name      = "resume-frontend-svc"
    namespace = "resume-app"
    labels = {
      job  = "astro-web"
      app  = "resume-frontend"
      tier = "frontend"
    }
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.frontend.spec[0].selector[0].match_labels.app
    }
    port {
      name        = "web-port"
      port        = 80
      target_port = "web-port"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_account_v1" "backend_sa" {
  metadata {
    name      = "backend-service-account"
    namespace = "resume-app"
    annotations = {
      "iam.gke.io/gcp-service-account" = var.service_account_email
    }
  }
}
