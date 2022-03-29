variable "k3s_config" {
  type        = string
  description = "The config file used to connect to Kubectl"
  default     = "~/.kube/config_k3s"
}
variable "K3S_CF_EMAIL" {
  description = ""
  type        = string
  default     = ""
}
variable "K3S_TRAEFIK_DASHBOARD" {
  description = ""
  type        = string
  default     = ""
}

variable "K3S_CF_API_KEY" {
  description = ""
  type        = string
  default     = ""
}
variable "K3S_CF_DOMAIN" {
  description = ""
  type        = string
  default     = ""
}

variable "K3S_GRAFANA_USER" {
  description = "The username to connect to Grafana UI."
  type        = string
  default     = ""
}

variable "K3S_GRAFANA_PASSWORD" {
  description = "The password to connect to Grafana UI."
  type        = string
  default     = ""
}

variable "K3S_OPENVPN_USERNAME" {
  description = "The username to connect to Grafana UI."
  type        = string
  default     = ""

}

variable "K3S_OPENVPN_PASSWORD" {
  description = "The username to connect to Grafana UI."
  type        = string
  default     = ""
}

variable "K3S_PIHOLE_PASSWORD" {
  description = ""
  type        = string
  default     = ""
}
