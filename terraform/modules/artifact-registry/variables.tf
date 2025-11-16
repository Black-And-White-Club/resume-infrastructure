variable "project_id" {
  description = "GCP Project ID"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "GCP region where the Artifact Registry will be created"
  type        = string
}

variable "repo_name" {
  description = "The name of the Artifact Registry repository"
  type        = string
  sensitive   = true
}

variable "compartment_ocid" {
  description = "OCI compartment OCID where repository should be created"
  type        = string
  default     = ""
}

variable "tenancy_namespace" {
  description = "OCI tenancy namespace used for OCIR (the namespace part of repository URL)"
  type        = string
  default     = ""
}

// DEPRECATED: artifact-registry module variables moved to the mono repo.
// Keep project tfvars for values; implementation is centralized.
