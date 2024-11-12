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
