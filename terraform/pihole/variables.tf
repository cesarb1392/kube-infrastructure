variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}


variable "TZ" {
  type = string
}

variable "primary_dns" {
  description = "Primary DNS"
  default     = "1.1.1.1"
}

variable "secondary_dns" {
  description = "Secondary DNS"
  default     = "4.4.4.4"
}

variable "password" {
  description = "Passwrod of the Web Interface"
}
