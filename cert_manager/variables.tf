variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "cert_manager_name" {
  type        = string
  description = "Cert Manager Helm name."
}
variable "cert_manager_repo" {
  type        = string
  description = "Cert Manager Helm repository name."
}
variable "cert_manager_version" {
  type        = string
  description = "Cert Manager Helm version."
}
