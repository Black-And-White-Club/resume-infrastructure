terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.7.0"
    }
  }
}
resource "google_container_cluster" "primary" {
  name     = "resume-app-cluster"
  location = "us-central1-a"

  enable_autopilot         = true
  deletion_protection      = true
  enable_l4_ilb_subsetting = true

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }
}

data "google_client_config" "default" {}


provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

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
          image = "us-central1-docker.pkg.dev/${var.project_id}/portfolio-app-images/resume-backend:d6ade94"
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
          image = "us-central1-docker.pkg.dev/${var.project_id}/portfolio-app-images/resume-frontend:039598c"
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
      app = kubernetes_deployment_v1.frontend.spec[0].selector[0].match_labels.app # Corrected index
    }
    port {
      name        = "web-port"
      port        = 80
      target_port = "web-port"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "main" {
  metadata {
    name      = "resume-app-ingress"
    namespace = "resume-app"
  }

  spec {
    tls {
      hosts       = ["jaromero.cloud"]
      secret_name = module.google_cert_manager.google_managed_cert_name # Reference the Google-managed cert
    }
    rule {
      host = "jaromero.cloud"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.frontend.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
        path {
          path      = "/api/count"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.backend.metadata[0].name
              port {
                number = 8000
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_account_v1" "backend_sa" {
  metadata {
    name      = "backend-service-account"
    namespace = "resume-app"
    annotations = {
      "iam.gke.io/gcp-service-account" = module.cloud_sql.mysql_user_email # Accessing output from cloud_sql module
    }
  }
}
