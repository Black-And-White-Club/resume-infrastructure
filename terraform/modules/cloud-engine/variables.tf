variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The region to deploy all GCP resources"
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
  sensitive   = true
}

variable "local_ip" {
  description = "My IP"
  type        = list(string)
  sensitive   = true
}

variable "zone" {
  type        = string
  description = "The Zone to deploy GCP Resources"
}

variable "backend_http_port" {
  type        = number
  description = "Port used by the ingress/nodeport that the external LB will target"
  default     = 30645
}
