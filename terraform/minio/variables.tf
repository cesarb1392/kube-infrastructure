variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}
variable "app_name" {
  description = "app_name"
  type        = string
}

variable "target_service" {
  description = "target_service"
  type        = string
}

variable "ingress_port" {
  description = "ingress_port"
  type        = string
}

variable "lan_ip" {
  description = "lan_ip"
  type        = string
}

variable "MINIO_USERS" {
  description = "minio api users"
  type = list(
    object({
      accessKey = string
      secretKey = string
      policy    = string
  }))
  sensitive = true
}

variable "MINIO_ROOT_USER" {
  type      = string
  sensitive = true
}
variable "MINIO_ROOT_PASSWORD" {
  type      = string
  sensitive = true
}

variable "persistent_volume_claim_name" {
  type = string
}