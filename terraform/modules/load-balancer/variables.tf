variable "project_id" {
  type        = string
  description = "The ID of the GCP project"
}

variable "region" {
  type        = string
  description = "Region for resources (used for MIG if needed)"
}

variable "backend_instance_self_link" {
  type        = string
  description = "Self link of the backend VM instance to attach via unmanaged instance group"
}

variable "zone" {
  type        = string
  description = "Zone of the backend instance/group"
}

variable "ssl_certificate_ids" {
  type        = list(string)
  description = "List of SSL certificate self_links or names for the HTTPS proxy"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for LB resource names"
  default     = "resume-app"
}

variable "backend_http_port" {
  type        = number
  description = "Port on backend instances to receive HTTP from LB (NodePort or service port)"
  default     = 80
}

