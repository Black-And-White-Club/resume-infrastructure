variable "instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
  default     = "resume-app-instance"
}

variable "region" {
  description = "The region to deploy the Cloud SQL instance"
  type        = string
  default     = "us-central1"
}

variable "backup_start_time" {
  description = "The time of day (UTC) when automated backups start"
  type        = string
  default     = "03:00"
}

variable "database_name" {
  description = "Name of the MySQL database"
  type        = string
  default     = "resume_app"
}

variable "db_user_name" {
  description = "The database user name"
  type        = string
  default     = "root"
}

variable "db_password" {
  description = "The database user password"
  type        = string
  sensitive   = true
}

variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project."
}
