resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = var.namespace

  values = [yamlencode(local.chart_config)]
}

locals {
  chart_config = {
    #    https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
  }
}