variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "app_name" {
  description = "app_name"
  type        = string
}

variable "app_image" {
  description = "app_image"
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