variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "TZ" {
  type = string
}

variable "target_service" {
  description = "target_service"
  type        = string
}
variable "ingress_port" {
  description = "ingress_port"
  type        = string
}
variable "CF_ZONE_NAME" {
  type = string
}