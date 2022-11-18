variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "private_key" {
  description = "private_key"
  type        = string
}

variable "user" {
  type = string
}
variable "password" {
  type = string
}

variable "host_ip" {
  type = string
}

variable "persistent_volume_claim_name" {
  type = string
}