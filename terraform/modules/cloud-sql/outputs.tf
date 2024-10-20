output "instance_connection_name" {
  value       = google_sql_database_instance.default.connection_name
  description = "Connection name of the Cloud SQL instance"
}

output "public_ip_address" {
  value = {
    for network in google_sql_database_instance.default.settings[0].ip_configuration[0].authorized_networks :
    network.name => network.value
  }
  description = "Public IP addresses of the Cloud SQL instance"
}

output "database_name" {
  value       = google_sql_database.default.name
  description = "Name of the created database"
}

output "user_name" {
  value       = google_sql_user.default.name
  description = "Name of the created user"
}
