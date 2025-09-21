module "artifact_registry" {
  source     = "./modules/artifact-registry/"
  project_id = var.project_id
  region     = var.region
  repo_name  = var.repo_name
}

module "cloud_engine" {
  source                = "./modules/cloud-engine/"
  project_id            = var.project_id
  zone                  = var.zone
  region                = var.region
  service_account_email = var.service_account_email
  local_ip              = var.local_ip
  backend_http_port     = var.backend_http_port
}

module "service_account" {
  source                = "./modules/service-account/"
  project_id            = var.project_id
  service_account_id    = var.service_account_id
  service_account_email = var.service_account_email
}

resource "google_compute_managed_ssl_certificate" "resume_cert" {
  name = "resume-cert"
  managed {
    domains = [
      "jaromero.cloud",
      "www.jaromero.cloud"
    ]
  }
}

module "load_balancer" {
  source                     = "./modules/load-balancer/"
  project_id                 = var.project_id
  region                     = var.region
  zone                       = var.zone
  backend_instance_self_link = module.cloud_engine.instance_self_link
  ssl_certificate_ids        = [google_compute_managed_ssl_certificate.resume_cert.name]
  name_prefix                = "resume-app"
  backend_http_port          = 30645
}
