variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "K3S_CF_EMAIL" {
  type = string
}

variable "K3S_CF_API_KEY" {
  type = string
}
variable "K3S_CF_DOMAIN" {
  type = string
}
variable "K3S_TRAEFIK_DASHBOARD" {
  type = string
}
