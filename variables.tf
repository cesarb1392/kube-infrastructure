variable "k3s_config" {
  type        = string
  description = "The config file used to connect to Kubectl"
  default     = "~/.kube/config_k3s"
}

variable "TRAEFIK_DASHBOARD" {
  description = ""
  type        = string
  default     = ""
}

variable "CF_DOMAIN" {
  description = ""
  type        = string
  default     = ""
}

variable "CF_EMAIL" {
  description = ""
  type        = string
}
variable "CF_API_TOKEN" {
  description = ""
  type        = string
}

variable "GRAFANA_USER" {
  description = "The username to connect to Grafana UI."
  type        = string
  default     = ""
}

variable "GRAFANA_PASSWORD" {
  description = "The password to connect to Grafana UI."
  type        = string
  default     = ""
}

variable "OPENVPN_USERNAME" {
  description = "The username to connect to Grafana UI."
  type        = string
  default     = ""

}

variable "OPENVPN_PASSWORD" {
  description = "The username to connect to Grafana UI."
  type        = string
  default     = ""
}

variable "PIHOLE_PASSWORD" {
  description = ""
  type        = string
  default     = ""
}


variable "ACCESS_TOKEN" {
  type = string
}
variable "REPO_URL" {
  type = string
}
variable "RUNNER_WORKDIR" {
  type = string
}
variable "RUNNER_NAME" {
  type = string
}

variable "SCRAPE_URL_BUY" {
  type = string
}
variable "SCRAPE_URL_RENT" {
  type = string
}
variable "EMAIL_FROM" {
  type = string
}
variable "EMAIL_TO" {
  type = string
}
variable "REFRESH_TOKEN" {
  type = string
}
variable "CLIENT_SECRET" {
  type = string
}
variable "CLIENT_ID" {
  type = string
}
