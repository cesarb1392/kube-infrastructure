#resource "helm_release" "kong" {
#  namespace  = var.namespace
#  name       = "kong"
#  repository = "https://charts.konghq.com"
#  chart      = "kong"
#  version    = "2.13.0"
#
#  values = [yamlencode(local.kong_config)]
#}

#resource "helm_release" "traefik" {
#  namespace  = var.namespace
#  name       = "traefik"
#  repository = "https://helm.traefik.io/traefik"
#  chart      = "traefik"
#  version    = "10.24.3"
#
#  values = [yamlencode(local.traefik_config)]
#}
