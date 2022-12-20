variable "db_name" {
  type    = string
}

variable "db_instance_name" {
  type    = string
}

variable "db_tier" {
  type    = string
}

variable "db_user_name" {
  type      = string
  sensitive = true
}

variable "db_user_password" {
  type      = string
  sensitive = true
}