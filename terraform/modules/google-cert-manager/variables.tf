variable "project_id" {
  type        = string
  description = "The GCP project ID"
}
variable "domains" {
  description = "List of domains for the SSL certificate"
  type        = list(string)
  default     = ["jaromero.cloud"]
}
