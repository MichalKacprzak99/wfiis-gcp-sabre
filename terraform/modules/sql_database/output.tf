output "cloudsql_instance_connection_name" {
  value = google_sql_database_instance.database_instance.connection_name
}

output "cloudsql_database_name" {
  value = google_sql_database.database.name
}
