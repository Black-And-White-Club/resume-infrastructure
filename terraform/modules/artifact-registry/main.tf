terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.7.0"
    }
  }
}
resource "google_artifact_registry_repository" "iac_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repo_name
  format        = "DOCKER"
  description   = "Resume Portfolio Docker Images"

  docker_config {
    immutable_tags = false
  }
}
