variable "CF_API_TOKEN" {
  type      = string
  sensitive = true

}

variable "KUBECONFIG" {
  type      = string
  sensitive = true

}

variable "TZ" {
  type      = string
  sensitive = true
}
variable "CF_ACCESS_EMAIL_LIST" {
  type      = list(string)
  sensitive = true
}
variable "CF_ZONE_ID" {
  type      = string
  sensitive = true
}
variable "CF_ACCOUNT_ID" {
  type      = string
  sensitive = true
}
variable "CF_ZONE_NAME" {
  type      = string
  sensitive = true
}

variable "MINIO_ROOT_USER" {
  type      = string
  sensitive = true
}
variable "MINIO_ROOT_PASSWORD" {
  type      = string
  sensitive = true
}
variable "MINIO_USERS" {
  type = list(
    object({
      accessKey = string
      secretKey = string
      policy    = string
  }))
  sensitive = true

}

variable "PI_HOLE_PASS" {
  type      = string
  sensitive = true
}

variable "WG_PRIVATE_KEY" {
  type      = string
  sensitive = true
}

variable "WG_USER" {
  type      = string
  sensitive = true
}
variable "WG_PASSWORD" {
  type      = string
  sensitive = true
}

variable "GH_ACCESS_TOKEN" {
  type      = string
  sensitive = true
}
variable "VAULTWARDEN_ADMIN_TOKEN" {
  type      = string
  sensitive = true
}

variable "OPENVPN_PRIVATE_KEY" {
  description = ""
  type        = string
  sensitive   = true
}

variable "vpn_country" {
  type = string
}

variable "PUID" {
  description = ""
  type        = string
}

variable "PGID" {
  description = ""
  type        = string
}

variable "USER" {
  description = ""
  type        = string
}

variable "PASS" {
  description = ""
  type        = string
}

variable "PUBLIC_IP" {
  description = ""
  type        = string
}