variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "K3S_OPENVPN_USERNAME" {
  description = ""
  type        = string
}

variable "K3S_OPENVPN_PASSWORD" {
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
