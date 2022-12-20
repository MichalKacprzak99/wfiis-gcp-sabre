variable "container_registry_hostname" {
  type = string
}

variable "region" {
  type = string
}

variable "cloud_run_name" {
  type = string
}

variable "project_id" {
  type = string
}
variable "project_num" {
  type = string
}


variable "name" {
  type    = string
  default = "api"
}

variable "included_files" {
  type    = string
  default = "src/api/**"
}

variable "branch" {
  type    = string
  default = "main"
}

variable "github_owner" {
  type    = string
  default = "MichalKacprzak99"
}

variable "github_repo_name" {
  type    = string
  default = "wfiis-gcp-sabre"
}

variable "filename" {
  type    = string
  default = "src/api/cloudbuild.yaml"
}
