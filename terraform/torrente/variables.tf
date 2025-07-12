variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "lan_ip" {
  type = string
}

variable "TOKEN" {
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

variable "persistent_volume_claim_name" {
  type = string
}

