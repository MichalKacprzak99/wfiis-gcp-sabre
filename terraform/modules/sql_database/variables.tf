variable "database_name" {
  type    = string
  default = "production"
}

variable "instance_name" {
  type    = string
  default = "wfiis-sabre"
}

variable "tier" {
  type    = string
  default = "db-f1-micro"
}

variable "user_name" {
  type      = string
  sensitive = true
}

variable "user_password" {
  type      = string
  sensitive = true
}