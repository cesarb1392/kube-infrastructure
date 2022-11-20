variable "namespace" {
  description = "The namespace where is installed"
  type        = string
}

variable "log_level" {
  description = "log level: `all`, `debug`, `info`, `warn`, `error` or `none`"
  type        = string
}

variable "address_pool" {
  type = string
}