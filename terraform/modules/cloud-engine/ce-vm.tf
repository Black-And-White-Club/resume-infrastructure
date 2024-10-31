// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "resume-project-vm" {
  project = var.project_id
  name    = "resume-project-vm"
  zone    = var.zone

  boot_disk {
    auto_delete = true

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20241009"
      size  = 30
      type  = "pd-standard"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward            = true
  deletion_protection       = false
  enable_display            = false
  allow_stopping_for_update = true

  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-x86-template-1-3-0"
  }

  machine_type = "t2d-standard-4"

  metadata = {
    enable-osconfig = "TRUE"
  }

  # Reference the subnetwork created in network.tf
  network_interface {
    subnetwork = google_compute_subnetwork.main.id
    access_config {
      network_tier = "STANDARD"
    }
  }

  scheduling {
    automatic_restart           = false
    on_host_maintenance         = "TERMINATE"
    preemptible                 = true
    provisioning_model          = "SPOT"
    instance_termination_action = "STOP"
  }

  service_account {
    email = var.service_account_email
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  # Tags for firewall rules
  tags = [
    "argocd",
    "backend-app",
    "grafana",
    "http-server",
    "https-server",
    "kubernetes-node",
    "lb-health-check",
    "prometheus",
    "web-app",
    "postgres"
  ]
}

// PVC for PostgresSQL
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk
resource "google_compute_disk" "db_storage" {
  name    = "db-storage"
  project = var.project_id
  zone    = var.zone
  type    = "pd-standard"
  size    = 10
}

resource "google_compute_attached_disk" "db_storage_attach" {
  instance = google_compute_instance.resume-project-vm.name
  project  = var.project_id
  zone     = var.zone
  disk     = google_compute_disk.db_storage.name
  mode     = "READ_WRITE"
}
