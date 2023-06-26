variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "lan_ip" {
  type = string
}

variable "PRIVATE_KEY" {
  description = ""
  type        = string
  sensitive   = true
}

variable "puid" {
  description = ""
  type        = string
}

variable "pgid" {
  description = ""
  type        = string
}

variable "timezone" {
  description = ""
  type        = string
}

variable "vpn_country" {
  type = string
}

variable "user" {
  description = ""
  type        = string
}

variable "pass" {
  description = ""
  type        = string
}
