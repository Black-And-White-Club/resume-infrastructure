terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_service_account" "default" {
  account_id = var.service_account_id
}

resource "google_project_iam_member" "gke_role" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "compute_engine_role" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "compute_os_login_role" {
  project = var.project_id
  role    = "roles/compute.osAdminLogin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "cloudsql_role" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "cloud_storage_role" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "artifact_registry_role" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "compute_network_admin_role" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "iam_service_account_user_role" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}
resource "google_project_iam_member" "cert_manager_role" {
  project = var.project_id
  role    = "roles/certificatemanager.owner"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

