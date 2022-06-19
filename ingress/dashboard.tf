resource "kubernetes_secret" "cert_api_keys" {
  metadata {
    name      = "cloudflare-api-credentials"
    namespace = var.namespace
  }
  data = {
    email  = var.K3S_CF_EMAIL
    apiKey = var.K3S_CF_API_KEY
  }

}

resource "kubernetes_config_map" "config" {
  metadata {
    name      = "traefik-config"
    namespace = var.namespace
  }
  data = {
    "traefik-config.yaml" = "" #yamlencode(kubernetes_manifest.default_headers)
  }
}

resource "kubernetes_secret" "secret_dashboard" {
  metadata {
    name      = "traefik-dashboard-auth"
    namespace = var.namespace
  }
  data = {
    #    https=//httpd.apache.org/docs/current/misc/password_encryptions.html
    #    users = var.K3S_TRAEFIK_DASHBOARD
    users = "quesito=$apr1$jExF1p/h$PRAyZVssDxLnETFnTLa7W0"
  }

}

#resource "kubernetes_manifest" "ingress_route" {
#  manifest = {
#    apiVersion = "traefik.containo.us/v1alpha1"
#    kind       = "IngressRoute"
#    metadata = {
#      name      = "traefik-dashboard"
#      namespace = var.namespace
#    }
#    spec = {
#      entryPoints = ["websecure"]
#      routes = [
#        {
#          #          match = "Host(`traefik.cesarb.dev`)"
#          match = "Host(`traefik.192.168.2.20.nip.io`)"
#          kind  = "Rule"
#          middlewares = [
#            {
#              name      = kubernetes_manifest.rate_limit.manifest.metadata.name
#              namespace = var.namespace
#            },
##            {
##              name      = "traefik-dashboard-basicauth"
##              namespace = var.namespace
##            },
#            #            {
#            #              name = "cloudflare-ip-whitelist"
#            #              namespace = var.namespace
#            #            },
#          ]
#          services = [
#            {
#              name = "api@internal"
#              kind = "TraefikService"
#            }
#          ]
#        }
#      ]
#    }
#  }
#}
