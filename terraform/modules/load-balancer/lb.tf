resource "google_compute_global_address" "lb_ip" {
  name    = "${var.name_prefix}-lb-ip"
  project = var.project_id
}

resource "google_compute_health_check" "default" {
  name    = "${var.name_prefix}-hc"
  project = var.project_id

  http_health_check {
    port         = var.backend_http_port
    request_path = "/"
  }
}

resource "google_compute_instance_group" "unmanaged" {
  name    = "${var.name_prefix}-uig"
  project = var.project_id
  zone    = var.zone

  instances = [var.backend_instance_self_link]

  named_port {
    name = "http"
    port = var.backend_http_port
  }
}

resource "google_compute_backend_service" "default" {
  name        = "${var.name_prefix}-backend"
  project     = var.project_id
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 10

  backend {
    group = google_compute_instance_group.unmanaged.self_link
  }

  health_checks = [google_compute_health_check.default.self_link]
}

resource "google_compute_url_map" "default" {
  name            = "${var.name_prefix}-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_url_map" "redirect" {
  name    = "${var.name_prefix}-redirect-map"
  project = var.project_id

  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.name_prefix}-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.redirect.self_link
}

resource "google_compute_target_https_proxy" "default" {
  name             = "${var.name_prefix}-https-proxy"
  project          = var.project_id
  url_map          = google_compute_url_map.default.self_link
  ssl_certificates = var.ssl_certificate_ids
}

resource "google_compute_global_forwarding_rule" "https" {
  name        = "${var.name_prefix}-https-rule"
  project     = var.project_id
  ip_address  = google_compute_global_address.lb_ip.address
  ip_protocol = "TCP"
  port_range  = "443"
  target      = google_compute_target_https_proxy.default.self_link
}

resource "google_compute_global_forwarding_rule" "http" {
  name        = "${var.name_prefix}-http-rule"
  project     = var.project_id
  ip_address  = google_compute_global_address.lb_ip.address
  ip_protocol = "TCP"
  port_range  = "80"
  target      = google_compute_target_http_proxy.default.self_link
}
