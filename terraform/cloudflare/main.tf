locals {
  cloudflare_tunnel = {
    cloudflare = {
      account    = var.CF_ACCOUNT_ID
      tunnelName = cloudflare_argo_tunnel.this.name
      # The ID of the above tunnel.
      tunnelId = cloudflare_argo_tunnel.this.id
      # The secret for the tunnel.
      secret = random_id.this.b64_std

      ingress = [
        {
          hostname = "${var.hostname}.${var.CF_ZONE_NAME}"
          service  = "http://${var.target_service}:${var.ingress_port}"
        },
        { hostname = "${var.hostname}.${var.CF_ZONE_NAME}", service = "http_status:404" }
      ]
    }
    replicaCount = 1
    resources = {
      limits = {
        cpu : "100m",
        memory : "128Mi"
      },
      memory = {
        cpu : "100m",
        memory : "128Mi"
      }
    }
  }
}

resource "helm_release" "cloudflare_tunnel" {
  chart      = "cloudflare-tunnel"
  name       = "cloudflare"
  repository = "https://cloudflare.github.io/helm-charts"
  namespace  = var.namespace
  version    = "0.3.0"

  values = [yamlencode(local.cloudflare_tunnel)]
}


resource "random_id" "this" {
  byte_length = 32
}

resource "cloudflare_argo_tunnel" "this" {
  account_id = var.CF_ACCOUNT_ID
  name       = "tunnel-${var.namespace}"
  secret     = random_id.this.b64_std
}