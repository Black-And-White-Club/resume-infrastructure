terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.7.0"
    }
  }
}

resource "google_certificate_manager_certificate" "default" {
  name = "resume-app-cert"
  managed {
    domains = ["jaromero.cloud"]
  }
}


resource "google_certificate_manager_certificate_map" "default" {
  name        = "resume-app-cert-map"
  description = "Certificate map for resume app"
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  name         = "resume-app-cert-entry"
  description  = "Entry for resume app certificate"
  map          = google_certificate_manager_certificate_map.default.name
  certificates = [google_certificate_manager_certificate.default.id]
  hostname     = "jaromero.cloud"
}
