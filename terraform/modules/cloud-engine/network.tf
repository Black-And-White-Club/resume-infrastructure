# Create the main network for the project
resource "google_compute_network" "main" {
  name                    = "resume-project-network"
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Create a subnetwork for the VMs to reside in
resource "google_compute_subnetwork" "main" {
  name          = "resume-project-subnet"
  ip_cidr_range = "10.128.0.0/20"
  region        = var.region
  network       = google_compute_network.main.id
  project       = var.project_id
}

# Firewall rule to allow Prometheus scraping on backend-app VMs
resource "google_compute_firewall" "allow-prometheus-scraping" {
  name    = "allow-prometheus-scraping"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }

  source_ranges = ["10.128.0.0/20"] # Restrict to internal subnet for security
  target_tags   = ["backend-app"]
}

# Firewall rule to allow ArgoCD (internal access)
resource "google_compute_firewall" "allow-argocd-internal" {
  name    = "allow-argocd-internal"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8080", "443"] # ArgoCD API and web interface ports
  }

  source_ranges = ["10.128.0.0/20"] # Internal VPC CIDR range
  target_tags   = ["argocd"]
}

resource "google_compute_firewall" "allow-kubernetes-internal" {
  name    = "allow-kubernetes-internal"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["10250", "10248", "6443", "10254"] # Kubelet, health check, and API server ports
  }

  source_ranges = ["10.128.0.0/20"]
  target_tags   = ["kubernetes-node", "nginx-ingress"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.local_ip
  target_tags   = ["kubernetes-node"]
}

resource "google_compute_firewall" "allow-argocd-prometheus-external" {
  name    = "allow-argocd-prometheus-external"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["31646", "30195"] # ArgoCD HTTPS NodePort
  }

  source_ranges = var.local_ip
  target_tags   = ["argocd", "prometheus"]
}

resource "google_compute_firewall" "allow-frontend-backend" {
  name    = "allow-frontend-backend"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["traefik"]

  source_ranges = ["0.0.0.0/0"] # Adjust as needed for security
}

resource "google_compute_firewall" "allow-lb-to-ingress" {
  name    = "allow-lb-to-ingress"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "30645", "32226"]
  }

  source_ranges = ["35.208.254.34"]
  target_tags   = ["nginx-ingress"]
}

resource "google_compute_firewall" "allow-health-checks" {
  name    = "allow-health-checks"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["30645", "32226"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["kubernetes-node"]
}
