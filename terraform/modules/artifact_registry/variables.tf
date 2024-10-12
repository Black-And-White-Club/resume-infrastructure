variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region where the Artifact Registry will be created"
  type        = string
  default     = "us-central1"
}

variable "repo_name" {
  description = "The name of the Artifact Registry repository"
  type        = string
  default     = "portfolio-app-images"
}
