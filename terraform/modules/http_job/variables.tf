variable "target" {
  type = string
}

variable "name" {
  type    = string
  default = "monitor-animes-episodes"
}

variable "schedule" {
  type    = string
  default = "0 20 * * *"
}

variable "time_zone" {
  type    = string
  default = "CET"
}