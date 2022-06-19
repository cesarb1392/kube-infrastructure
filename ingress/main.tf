resource "helm_release" "traefik" {
  namespace  = var.namespace
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "10.21.1"

  values = [yamlencode(local.traefik_config)]
}

