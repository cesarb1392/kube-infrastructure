variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "K3S_GRAFANA_USER" {
  description = "The username to connect to Grafana UI."
  type        = string
}

variable "K3S_GRAFANA_PASSWORD" {
  description = "The password to connect to Grafana UI."
  type        = string
}
