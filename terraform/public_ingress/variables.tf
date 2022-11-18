variable "namespace" {
  description = "The namespace where is installed"
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
variable "hostname" {
  type = string
}

variable "CF_ACCESS_EMAIL_LIST" {
  type = list(string)
}

variable "cf_access" {
  type    = string
  default = false
}
variable "CF_ZONE_ID" {
  type = string
}
variable "CF_ACCOUNT_ID" {
  type = string
}

variable "CF_ZONE_NAME" {
  type = string
}
