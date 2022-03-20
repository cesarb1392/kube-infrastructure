resource "kubernetes_secret" "cert_api_keys" {
  metadata {
    name      = "cloudflare-api-credentials"
    namespace = var.namespace
  }
  data = {
    email  = var.K3S_CF_EMAIL
    apiKey = var.K3S_CF_API_KEY
  }
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

resource "kubernetes_config_map" "config" {
  metadata {
    name      = "traefik-config"
    namespace = var.namespace
  }
  data = {
    "traefik-config.yaml" = file("${path.module}/traefik_dashboard_middleware.yaml")
  }
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

resource "kubernetes_secret" "secret_dashboard" {
  metadata {
    name      = "traefik-dashboard-auth"
    namespace = var.namespace
  }
  data = {
    users = var.K3S_TRAEFIK_DASHBOARD
  }
  depends_on = [
    kubernetes_namespace.traefik
  ]
}
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
    kubernetes_namespace.traefik
  ]
}

resource "kubernetes_manifest" "ingress_route" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "traefik-dashboard"
      namespace = var.namespace
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          match = "Host(`traefik.cesarb.dev`)"
          kind  = "Rule"
          middlewares = [
            {
              name : "traefik-dashboard-basicauth"
              namespace : var.namespace
            }
          ]
          services = [
            {
              name = "api@internal"
              kind = "TraefikService"
            }
          ]
        }
      ]
    }
  }
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

