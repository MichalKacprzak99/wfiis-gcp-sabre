variable "project_region" {
  type = string
}

variable "cloud_run_name" {
  type = string
}

variable "cloudsql_instance_connection_name" {
  type = string
}

variable "sql_alchemy_database_url" {
  type = string
}

variable "sendgrid_api_key" {
  type      = string
  sensitive = true
}

variable "docker_image" {
  type = string
}