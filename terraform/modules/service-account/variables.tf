variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The region to deploy resources in"
  type        = string
  default     = "us-central1"
}

// DEPRECATED: service-account variables have been consolidated to:
// all-infrastructure/terraform/modules/service-account/variables.tf
// Keep per-project tfvars for values but not implementations.
variable "service_account_id" {
  description = "The account ID for the service account"
  type        = string
  sensitive   = true
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
  sensitive   = true
}

variable "compartment_ocid" {
  description = "OCI compartment OCID where identity resources will be created (migration target)"
  type        = string
  default     = ""
}

variable "aiu_service_account_id" {
  description = "Logical name for the AIU user in OCI (migration target)"
  type        = string
  default     = "resume-aiu"
}
