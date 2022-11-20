variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "ACCESS_TOKEN" {
  type      = string
  sensitive = true
}
variable "repositories" {
  type = map(object({
    url = string
  }))
}
