variable "CF_API_TOKEN" {
  type = string
}

variable "KUBECONFIG" {
  type = string
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

variable "MINIO_ROOT_USER" {
  type = string
}
variable "MINIO_ROOT_PASSWORD" {
  type = string
}
variable "MINIO_USERS" {
  type = list(
    object({
      accessKey = string
      secretKey = string
      policy    = string
  }))
}