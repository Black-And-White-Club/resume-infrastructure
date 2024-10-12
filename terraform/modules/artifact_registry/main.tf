resource "google_artifact_registry_repository" "docker_repo" {
  project       = var.gcp_project_id
  location      = var.region
  repository_id = var.repo_name
  format        = "DOCKER"
  description   = "Resume Portfolio Docker Images"

  docker_config {
    immutable_tags = false
  }
}
