variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "K3S_OPENVPN_USERNAME" {
  description = "The username to connect to Grafana UI."
  type        = string
}

variable "K3S_OPENVPN_PASSWORD" {
  description = "The username to connect to Grafana UI."
  type        = string
}
