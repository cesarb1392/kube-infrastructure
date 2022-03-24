variable "k3s_config" {
  type        = string
  description = "The config file used to connect to Kubectl"
  default     = "~/.kube/config_k3s"
}
variable "K3S_CF_EMAIL" {
  type = string
}
variable "K3S_TRAEFIK_DASHBOARD" {
  type = string
}

variable "K3S_CF_API_KEY" {
  type = string
}
variable "K3S_CF_DOMAIN" {
  type = string
}

variable "K3S_GRAFANA_USER" {
  description = "The username to connect to Grafana UI."
  type        = string
}

variable "K3S_GRAFANA_PASSWORD" {
  description = "The password to connect to Grafana UI."
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
