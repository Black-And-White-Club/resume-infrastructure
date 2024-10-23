variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project."
  default     = var.project_id
}

variable "region" {
  description = "The region to deploy the Cloud SQL instance"
  type        = string
}
