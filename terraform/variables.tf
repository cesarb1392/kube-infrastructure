variable "CF_API_TOKEN" {
  type = string
}

variable "KUBECONFIG" {
  type = string
}

variable "TZ" {
  type = string
}
variable "CF_ACCESS_EMAIL_LIST" {
  type = list(string)
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

variable "PI_HOLE_PASS" {
  type = string
}

variable "WG_PRIVATE_KEY" {
  type = string
}

variable "WG_USER" {
  type = string
}
variable "WG_PASSWORD" {
  type = string
}

variable "GH_ACCESS_TOKEN" {
  type = string
}
variable "VAULTWARDEN_ADMIN_TOKEN" {
  type = string
}
variable "OPENVPN_USERNAME" {
  description = "The username to connect to Grafana UI."
  type        = string
}
variable "OPENVPN_PASSWORD" {
  description = "The username to connect to Grafana UI."
  type        = string
}