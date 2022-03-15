variable "namespace" {
  description = "The namespace where is installed"
  type        = string
  default     = "monitoring"
}

variable "grafana_user" {
  description = "The username to connect to Grafana UI."
  type        = string
  default     = "banana"
}

variable "grafana_password" {
  description = "The password to connect to Grafana UI."
  type        = string
  default     = "password"
}
