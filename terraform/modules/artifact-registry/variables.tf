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

variable "zone" {
  type        = string
  description = "The Zone to deploy GCP Resources"
}
