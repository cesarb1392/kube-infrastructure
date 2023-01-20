variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}
variable "TZ" {
  type = string
}

variable "available" {
  type = map(bool)
}
variable "puid" {
  description = ""
  type        = string
}

variable "pgid" {
  description = ""
  type        = string
}