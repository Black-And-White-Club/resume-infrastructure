// DEPRECATED: service-account outputs are provided by the central module.
// See: all-infrastructure/terraform/modules/service-account/outputs.tf

output "service_account_email" {
  description = "Compatibility: previously a GCP SA email. Now maps to the OCI user name for migration purposes."
  value       = module.sa_shared.service_account_name
}

output "service_account_name" {
  description = "Logical name of the application user (OCI)"
  value       = module.sa_shared.service_account_name
}

output "aiu_service_account_email" {
  description = "Compatibility: previously a GCP AIU SA email. Now maps to the OCI AIU user name."
  value       = module.sa_shared.aiu_service_account_name
}

output "aiu_service_account_name" {
  description = "Logical name of the AIU user (OCI)"
  value       = module.sa_shared.aiu_service_account_name
}
