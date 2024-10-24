terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.7.0"
    }
  }
}
data "google_sql_database_instance" "default" {
  name    = var.instance_name
  project = var.project_id
}

data "google_sql_database" "default" {
  name     = var.database_name
  instance = data.google_sql_database_instance.default.name
  project  = var.project_id
}

resource "google_sql_user" "default" {
  name     = var.db_user_name
  instance = data.google_sql_database_instance.default.name
  project  = var.project_id
  password = var.db_password
}
