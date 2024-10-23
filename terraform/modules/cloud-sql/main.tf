terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.7.0"
    }
  }
}
resource "google_sql_database_instance" "default" {
  name             = var.instance_name
  database_version = "MYSQL_8_4"
  region           = var.region
  project          = var.project_id

  settings {
    tier              = "db-f1-micro" # Smallest predefined machine type (shared vCPU, 0.6GB RAM)
    availability_type = "ZONAL"

    backup_configuration {
      enabled    = true
      start_time = var.backup_start_time
    }

    ip_configuration {
      ipv4_enabled = true
    }

    disk_autoresize = true
    disk_size       = 10
    disk_type       = "PD_HDD"

    location_preference {
      zone = "us-central1-c"
    }

    maintenance_window {
      day          = 7
      hour         = 3
      update_track = "stable"
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "default" {
  name      = var.database_name
  instance  = google_sql_database_instance.default.name
  project   = var.project_id
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "default" {
  name     = var.db_user_name
  instance = google_sql_database_instance.default.name
  project  = var.project_id
  password = var.db_password
}
