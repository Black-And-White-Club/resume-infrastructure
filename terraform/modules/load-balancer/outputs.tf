output "ip_address" {
  description = "Compatibility: maps to the OCI load balancer IP addresses output (inspect value and adapt callers as needed)"
  value       = module.lb_shared.load_balancer_ip_addresses
}

// DEPRECATED: load-balancer outputs are now provided by the centralized
// module at all-infrastructure/terraform/modules/load-balancer
