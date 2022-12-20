# GENERAL
variable "project_region" {
  type = string
}

variable "project_number" {
  type = string
}

variable "project_id" {
  type = string
}

# CLOUD RUN

variable "cloud_run_name" {
  type = string
}

# CLOUD BUILD TRIGGER

variable "container_registry_hostname" {
  type = string
}

variable "cloud_build_trigger_name" {
  type = string
}

variable "cloud_build_trigger_included_files" {
  type = string
}

variable "cloud_trigger_build_filename" {
  type = string
}

variable "github_repo_trigger_branch" {
  type = string
}

variable "github_repo_owner" {
  type = string
}

variable "github_repo_name" {
  type = string
}


