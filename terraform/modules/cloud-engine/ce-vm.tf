resource "google_compute_network" "main" {
  name                    = "resume-project-network"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "main" {
  name          = "resume-project-subnet"
  ip_cidr_range = "10.128.0.0/20"
  region        = var.region
  network       = google_compute_network.main.id
  project       = var.project_id
}

resource "google_compute_instance" "resume-project-vm" {
  project = var.project_id
  boot_disk {
    auto_delete = true
    device_name = "instance-20241024-123846"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20241009"
      size  = 30
      type  = "pd-standard"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = true
  deletion_protection = false
  enable_display      = true

  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-x86-template-1-3-0"
  }

  machine_type = "e2-medium"

  metadata = {
    enable-osconfig = "TRUE"
  }

  name = "resume-project-vm"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/resume-portfolio-project/regions/us-central1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
    preemptible         = true
    provisioning_model  = "SPOT"
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["argocd", "backend-app", "grafana", "http-server", "https-server", "kubernetes-node", "lb-health-check", "prometheus", "web-app"]
  zone = "us-central1-a"
}


resource "google_compute_firewall" "allow-https" {
  name    = "allow-https"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-app"]
}

resource "google_compute_firewall" "allow-backend-traffic" {
  name    = "allow-backend-traffic"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  source_ranges = ["0.0.0.0/0"] # Consider restricting this in production
  target_tags   = ["backend-app"]
}

resource "google_compute_firewall" "allow-prometheus-scraping" {
  name    = "allow-prometheus-scraping"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8000"] # Port used by the ServiceMonitor
  }

  source_ranges = ["10.128.0.0/20"] # Adjust this to your pod/service CIDR range
  target_tags   = ["backend-app"]
}
