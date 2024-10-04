variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
  default     = "resume-portfolio-project" // Your actual project ID
}

variable "region" {
  description = "The region to deploy resources in"
  type        = string
  default     = "us-central1" // Your preferred region
}

variable "service_account_id" {
  description = "The account ID for the service account"
  type        = string
  default     = "resume-app-sa"
}

variable "service_account_display_name" {
  description = "The display name for the service account"
  type        = string
  default     = "Resume App Service Account"
}
