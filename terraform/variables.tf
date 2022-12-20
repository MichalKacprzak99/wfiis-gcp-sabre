variable "project_id" {
  type = string
}

variable "project_number" {
  type = number
}

variable "project_region" {
  type    = string
  default = "europe-central2"
}

variable "cloud_run_name" {
  type    = string
  default = "wfiis-gcp-sabre"
}

variable "container_registry_hostname" {
  type    = string
  default = "eu.gcr.io"
}

variable "user_name" {
  type      = string
  sensitive = true
}

variable "user_password" {
  type      = string
  sensitive = true
}

variable "sendgrid_api_key" {
  type      = string
  sensitive = true
}