data "google_service_account" "default" {
  account_id = var.service_account_id
  project    = var.project_id
}

resource "google_service_account" "default" {
  account_id = var.service_account_id
  project    = var.project_id
}

resource "google_project_iam_member" "compute_engine_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "compute_os_login_admin" {
  project = var.project_id
  role    = "roles/compute.osAdminLogin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "cloud_storage_object_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "artifact_registry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "compute_network_admin_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "iam_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}
resource "google_project_iam_member" "cert_manager_owner" {
  project = var.project_id
  role    = "roles/certificatemanager.owner"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "api_keys_admin" {
  project = var.project_id
  role    = "roles/serviceusage.apiKeysAdmin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "service_account_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "service_usage_admin" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}

resource "google_project_iam_member" "service_account_viewer" {
  project = var.project_id
  role    = "roles/iam.serviceAccountViewer"
  member  = "serviceAccount:${data.google_service_account.default.email}"
}
