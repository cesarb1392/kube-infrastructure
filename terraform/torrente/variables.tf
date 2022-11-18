variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "persistent_volume_claim_name" {
  type = string
}

variable "host_ip" {
  type = string
}

variable "OPENVPN_USERNAME" {
  description = ""
  type        = string
}

variable "OPENVPN_PASSWORD" {
  description = ""
  type        = string
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
