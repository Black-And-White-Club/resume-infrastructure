# /resume-project/variables.tf
variable "project_id" {
  description = "The ID of the project"
  type        = string
}

variable "region" {
  description = "The region for resources"
  type        = string
}

variable "repo_name" {
  description = "The name of the artifact repository"
  type        = string
}

variable "zone" {
  description = "The zone for the VM"
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account"
  type        = string
}

variable "service_account_id" {
  description = "The ID of the service account"
  type        = string
}

variable "local_ip" {
  description = "Local IP address for firewall rules"
  type        = list(string)
}

variable "backend_http_port" {
  description = "Port on backend instances (NodePort or service) that LB will send HTTP traffic to"
  type        = number
  default     = 30645
}
