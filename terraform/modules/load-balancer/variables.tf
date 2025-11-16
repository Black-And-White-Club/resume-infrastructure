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

variable "compartment_ocid" {
  description = "OCI compartment OCID where the load balancer should be created"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of OCI subnet OCIDs to place the load balancer in"
  type        = list(string)
  default     = []
}

variable "backend_instance_ocids" {
  description = "List of backend instance OCIDs for the OCI load balancer"
  type        = list(string)
  default     = []
}

// DEPRECATED: load-balancer variables moved to centralized module
// See: all-infrastructure/terraform/modules/load-balancer

