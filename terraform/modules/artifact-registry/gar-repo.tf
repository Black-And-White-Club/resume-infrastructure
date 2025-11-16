// DEPRECATED: artifact-registry implementation moved to the centralized
// all-infrastructure/terraform/modules/artifact-registry

// Wrapper for centralized OCIR repository
module "artifact_registry_shared" {
  source = "git::ssh://git@github.com/YOUR_ORG/all-infrastructure.git//terraform/modules/artifact-registry?ref=migrate-service-account"

  compartment_ocid  = var.compartment_ocid
  tenancy_namespace = var.tenancy_namespace
  repo_name         = var.repo_name
}
