// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "resume-project-vm" {
  project = var.project_id
  name    = "resume-project-vm"
  zone    = var.zone

  boot_disk {
    auto_delete = true

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20241009"
      size  = 40
      type  = "pd-standard"
    }

    mode = "READ_WRITE"
  }

  attached_disk {
    source      = google_compute_disk.db_storage.self_link
    mode        = "READ_WRITE"
    device_name = "db-storage"
  }

  attached_disk {
    source      = data.google_compute_disk.frolf_bot_postgres.self_link
    mode        = "READ_WRITE"
    device_name = "frolf-bot-postgres"
  }

  attached_disk {
    source      = data.google_compute_disk.frolf_bot_grafana.self_link
    mode        = "READ_WRITE"
    device_name = "frolf-bot-grafana"
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
    startup-script  = file("${path.module}/mount-disks.sh")
  }

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
    "postgres",
    "nginx-ingress",
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

// Storage Disks for Frolf-Bot
// Has to be attached here because all of the VM stuff is here 
// Sorry... I didn't expect to have multiple projects so this will need to be cleaned up in the future if
// I ever separate the apps from each other. 
data "google_compute_disk" "frolf_bot_postgres" {
  name    = "frolf-bot-postgres-disk"
  project = var.project_id
  zone    = var.zone
}

data "google_compute_disk" "frolf_bot_grafana" {
  name    = "frolf-bot-grafana-disk"
  project = var.project_id
  zone    = var.zone
}
