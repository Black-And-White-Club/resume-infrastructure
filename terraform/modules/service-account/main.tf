terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.5.0"
    }
  }
}

# Configure the Google Cloud provider with your project ID
provider "google" {
  project = "resume-portfolio-project" # Replace with your actual project ID
  region  = "us-central1"              # Or your preferred region
}

resource "google_service_account" "service_account" {
  account_id   = "resume-app-sa"
  display_name = "Resume App Service Account"
}

resource "google_project_iam_member" "terraform_binding" {
  project = "resume-portfolio-project"
  role    = "roles/container.admin" # For GKE
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "compute_binding" {
  project = "resume-portfolio-project"
  role    = "roles/compute.admin" # For Compute Engine
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "cloudsql_binding" {
  project = "resume-portfolio-project"
  role    = "roles/cloudsql.admin" # For Cloud SQL
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "app_binding" {
  project = "resume-portfolio-project"
  role    = "roles/storage.objectAdmin" # Example app role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "arc_binding" {
  project = "resume-portfolio-project"
  role    = "roles/artifactregistry.admin" # Example app role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
