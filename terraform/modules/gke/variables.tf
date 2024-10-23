variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
}

variable "db_password" {
  description = "The database user password"
  type        = string
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The region to deploy all GCP resources"
  default     = "us-central1"
}
