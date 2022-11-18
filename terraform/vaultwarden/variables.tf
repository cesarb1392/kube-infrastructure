variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "ingress_port" {
  type = number
}

variable "SERVER_ADMIN_EMAIL" {
  type = string
}
variable "DOMAIN" {
  type = string
}

variable "VAULTWARDEN_ADMIN_TOKEN" {
  type = string
}
variable "persistent_volume_claim_name" {
  type = string
}