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
}

module "service_account" {
  source                = "./modules/service-account/"
  project_id            = var.project_id
  service_account_id    = var.service_account_id
  service_account_email = var.service_account_email
}
