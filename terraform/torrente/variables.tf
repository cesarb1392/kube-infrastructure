variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "host_ip" {
  type = string
}

variable "OPENVPN_USERNAME" {
  description = ""
  type        = string
  sensitive   = true

}

variable "OPENVPN_PASSWORD" {
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
