variable "compartment_ocid" {
  description = "OCI compartment OCID"
  type        = string
}

variable "availability_domain" {
  description = "OCI availability domain"
  type        = string
}

variable "image_id" {
  description = "OCI image OCID to use for instances"
  type        = string
}

variable "shape" {
  description = "OCI instance shape"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
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

variable "ssl_certificate_ids" {
  description = "List of OCI certificate OCIDs to attach to HTTPS listener"
  type        = list(string)
  default     = []
}

variable "tenancy_namespace" {
  description = "OCI tenancy namespace used for OCIR (the namespace part of repository URL)"
  type        = string
}
