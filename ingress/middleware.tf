resource "kubernetes_manifest" "config_basicauth" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "traefik-dashboard-basicauth"
      namespace = var.namespace
    }
    spec = {
      basicAuth = {
        secret = "traefik-dashboard-auth"
      }
    }
  }
  depends_on = [

  ]
}

resource "kubernetes_manifest" "cloudflare_ipwhitelist_middleware" {
  manifest = {
    "apiVersion" = "traefik.containo.us/v1alpha1"
    kind         = "Middleware"
    metadata = {
      name      = "cloudflare-ipwhitelist"
      namespace = var.namespace
    }
    spec = {
      ipWhiteList = {
        sourceRange = [
          "173.245.48.0/20"
          , "103.21.244.0/22"
          , "103.22.200.0/22"
          , "103.31.4.0/22"
          , "141.101.64.0/18"
          , "108.162.192.0/18"
          , "190.93.240.0/20"
          , "188.114.96.0/20"
          , "197.234.240.0/22"
          , "198.41.128.0/17"
          , "162.158.0.0/15"
          , "104.16.0.0/13"
          , "104.24.0.0/14"
          , "172.64.0.0/13"
          , "131.0.72.0/22"
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "rate_limit" {
  manifest = {
    "apiVersion" = "traefik.containo.us/v1alpha1"
    kind         = "Middleware"
    metadata = {
      name      = "rate-limit"
      namespace = var.namespace
    }
    spec = {
      rateLimit = {
        period : "1m"
        average : 500
        burst : 300
      }
    }
  }
}
