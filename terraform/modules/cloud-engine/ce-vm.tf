// DEPRECATED: cloud-engine implementation moved to all-infrastructure/terraform/modules/cloud-engine
// See the shared module for the OCI implementation and helpers.

// Wrapper: delegate compute/network/volume attachments to the central OCI cloud-engine module.
// The shared cloud-engine module implements the VCN, subnet, instance and volume
// attachments in OCI; this thin wrapper preserves the original module interface so
// top-level code can remain stable during the migration.
module "cloud_engine_shared" {
  source = "git::ssh://git@github.com/YOUR_ORG/all-infrastructure.git//terraform/modules/compute?ref=migrate-service-account"

  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain
  image_id            = var.image_id
  shape               = var.shape
  ssh_public_key      = var.ssh_public_key
  vcn_cidr            = var.vcn_cidr
  subnet_cidr         = var.subnet_cidr
  backend_http_port   = var.backend_http_port
}
