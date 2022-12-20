#GENERAL
variable "project_id" {
  type = string
}

variable "project_number" {
  type = number
}

variable "project_region" {
  type    = string
}

# SQL DB

variable "db_user_name" {
  type      = string
  sensitive = true
}

variable "db_user_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
}

variable "db_instance_name" {
  type    = string
}

variable "db_tier" {
  type    = string
}

# CLOUD RUN

variable "cloud_run_name" {
  type    = string
}

variable "sendgrid_api_key" {
  type      = string
  sensitive = true
}

# CLOUD SCHEDULER

variable "scheduler_name" {
  type    = string
}

variable "scheduler_cron_time" {
  type    = string
}

variable "scheduler_time_zone" {
  type    = string
}

# CLOUD BUILD TRIGGER

variable "container_registry_hostname" {
  type = string
}

variable "cloud_build_trigger_name" {
  type    = string
}

variable "cloud_build_trigger_included_files" {
  type    = string
}

variable "github_repo_trigger_branch" {
  type    = string
}

variable "github_repo_owner" {
  type    = string
}

variable "github_repo_name" {
  type    = string
}

variable "cloud_trigger_build_filename" {
  type    = string
}




