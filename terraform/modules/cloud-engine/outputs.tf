output "instance_self_link" {
  description = "Self link of the primary VM instance to attach to LB backends"
  value       = google_compute_instance.resume-project-vm.self_link
}

output "network_name" {
  description = "VPC network name"
  value       = google_compute_network.main.name
}

output "subnetwork_self_link" {
  description = "Subnetwork self link"
  value       = google_compute_subnetwork.main.self_link
}
