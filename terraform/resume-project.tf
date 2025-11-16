module "artifact_registry" {
  # For local testing you can point to a relative path:
  # source = "../all-infrastructure/terraform/modules/artifact-registry"
  source            = "git::ssh://git@github.com/YOUR_ORG/all-infrastructure.git//terraform/modules/container-registry?ref=migrate-service-account"
  compartment_ocid  = var.compartment_ocid
  tenancy_namespace = var.tenancy_namespace
  repo_name         = var.repo_name
}

module "disks" {
  source                      = "git::ssh://git@github.com/YOUR_ORG/all-infrastructure.git//terraform/modules/block-storage?ref=migrate-service-account"
  compartment_ocid            = var.compartment_ocid
  default_availability_domain = var.availability_domain
  disks = {
    db_storage = {
      name                = "db-storage"
      size                = 8
      availability_domain = var.availability_domain
    }
  }
}

module "cloud_engine" {
  # For local testing you can point to a relative path:
  # source = "../all-infrastructure/terraform/modules/cloud-engine"
  source              = "git::ssh://git@github.com/YOUR_ORG/all-infrastructure.git//terraform/modules/compute?ref=migrate-service-account"
  project_id          = var.project_id
  zone                = var.zone
  region              = var.region
  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain
  image_id            = var.image_id
  shape               = var.shape
  ssh_public_key      = var.ssh_public_key
  vcn_cidr            = var.vcn_cidr
  subnet_cidr         = var.subnet_cidr
  disk_ocids          = module.disks.disk_ocids
}

module "service_account" {
  # Call the centralized OCI implementation directly during migration. For
  # local iterating you can point this at a relative path to the shared repo.
  source = "git::ssh://git@github.com/YOUR_ORG/all-infrastructure.git//terraform/modules/identity-users?ref=migrate-service-account"

  service_account_id     = var.service_account_id
  aiu_service_account_id = var.aiu_service_account_id
  compartment_ocid       = var.compartment_ocid
}

// Google-managed SSL cert removed for OCI migration. Create OCI certs and pass their OCIDs via the
// `ssl_certificate_ids` variable when ready.

module "load_balancer" {
  source                 = "git::ssh://git@github.com/YOUR_ORG/all-infrastructure.git//terraform/modules/load-balancer?ref=migrate-service-account"
  compartment_ocid       = var.compartment_ocid
  subnet_ids             = [module.cloud_engine.subnet_id]
  backend_instance_ocids = [module.cloud_engine.instance_ocid]
  ssl_certificate_ids    = var.ssl_certificate_ids
  name_prefix            = "resume-app"
  backend_http_port      = var.backend_http_port
}
