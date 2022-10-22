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

variable "MINIO_USERS" {
  description = "omnio users"
  type = list(
    object({
      accessKey = string
      secretKey = string
      policy    = string
  }))
}

variable "MINIO_ROOT_USER" {
  type = string
}
variable "MINIO_ROOT_PASSWORD" {
  type = string
}
