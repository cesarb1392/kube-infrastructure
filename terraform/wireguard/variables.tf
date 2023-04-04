variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "private_key" {
  description = "private_key"
  type        = string
  sensitive   = true
}

variable "user" {
  type = string
}
variable "password" {
  type      = string
  sensitive = true
}

variable "lan_ip" {
  type = string
}

variable "log_level" {
  type = string
}

variable "persistent_volume_claim_name" {
  type = string
}