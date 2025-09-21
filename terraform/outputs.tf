output "load_balancer_ip" {
  description = "Global IP address of the resume app load balancer"
  value       = module.load_balancer.ip_address
}
