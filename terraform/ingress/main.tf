resource "helm_release" "kong" {
  namespace  = var.namespace
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"
  version    = "2.13.0"

  values = [yamlencode(local.kong_config)]

}

