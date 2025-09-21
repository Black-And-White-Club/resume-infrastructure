output "ip_address" {
  description = "Reserved global IP for the load balancer"
  value       = google_compute_global_address.lb_ip.address
}
