// DEPRECATED: local load-balancer implementation moved to
// all-infrastructure/terraform/modules/load-balancer
// This placeholder prevents accidental usage of local GCP LB resources.

// Wrapper: use centralized OCI load balancer implementation
module "lb_shared" {
  source = "git::ssh://git@github.com/YOUR_ORG/all-infrastructure.git//terraform/modules/load-balancer?ref=migrate-service-account"

  compartment_ocid       = var.compartment_ocid
  subnet_ids             = var.subnet_ids
  backend_instance_ocids = var.backend_instance_ocids
  ssl_certificate_ids    = var.ssl_certificate_ids
  name_prefix            = var.name_prefix
  backend_http_port      = var.backend_http_port
}
