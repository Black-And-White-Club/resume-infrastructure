variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project."
  sensitive   = true
}

variable "region" {
  description = "The region to deploy the Cloud SQL instance"
  type        = string
}

variable "zone" {
  type        = string
  description = "The Zone to deploy GCP Resources"
}
