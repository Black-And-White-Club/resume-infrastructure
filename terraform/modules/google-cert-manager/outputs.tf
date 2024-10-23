output "google_managed_cert_name" {
  value = google_certificate_manager_certificate.default.name # Add this if using Google-managed certs
}
