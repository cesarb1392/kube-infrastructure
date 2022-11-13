variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "ACCESS_TOKEN" {
  type = string
}
variable "repositories" {
  type = map(object({
    url = string
  }))
}

variable "RUNNER_NAME" {
  type = string
}
