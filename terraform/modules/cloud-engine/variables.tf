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

variable "compartment_ocid" {
  description = "OCI compartment OCID for migration target"
  type        = string
  default     = ""
}

variable "availability_domain" {
  description = "OCI availability domain"
  type        = string
  default     = ""
}

variable "image_id" {
  description = "OCI image OCID to use for instances"
  type        = string
  default     = ""
}

variable "shape" {
  description = "OCI instance shape"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
  default     = ""
}

variable "vcn_cidr" {
  description = "VCN CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

// DEPRECATED: cloud-engine module variables were consolidated to the
// shared module in `all-infrastructure`. Keep project tfvars for deployment
// values (compartment_ocid, availability_domain, etc.).
