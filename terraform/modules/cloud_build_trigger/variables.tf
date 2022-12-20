variable "name" {
  type = string
}

variable "included_files" {
  type = string
}

variable "branch" {
  type = string
}

variable "project_id" {
  type    = string
  default = ""
}

variable "container_registry_hostname" {
  type = string
}

variable "region" {
  type = string
}

variable "cloud_run_name" {
  type = string
}
