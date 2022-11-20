variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "ingress_port" {
  type = number
}

variable "SERVER_ADMIN_EMAIL" {
  type      = string
  sensitive = true
}
variable "DOMAIN" {
  type      = string
  sensitive = true
}

variable "VAULTWARDEN_ADMIN_TOKEN" {
  type      = string
  sensitive = true
}
variable "persistent_volume_claim_name" {
  type = string
}

variable "log_level" {
  type = string
}