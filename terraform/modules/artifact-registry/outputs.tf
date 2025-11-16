// DEPRECATED: artifact-registry outputs are now produced by the centralized
// module at all-infrastructure/terraform/modules/artifact-registry

output "repository_ocid" {
  description = "OCID of the created repository (OCI) from centralized module"
  value       = module.artifact_registry_shared.repository_ocid
}

output "repository_url" {
  description = "Repository URL (OCIR) from centralized module"
  value       = module.artifact_registry_shared.repository_url
}

