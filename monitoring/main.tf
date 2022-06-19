resource "helm_release" "grafana" {
  chart      = "grafana"
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = var.namespace
  version    = "6.30.2"

  values = [yamlencode(local.grafana_config)]
}

resource "helm_release" "prometheus" {
  chart      = "prometheus"
  name       = var.namespace
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "15.10.1"

  values = [yamlencode(local.prometheus_config)]
}

resource "helm_release" "netdata" {
  chart      = "netdata"
  name       = "netdata"
  repository = "https://netdata.github.io/helmchart"
  namespace  = var.namespace

  values = [yamlencode(local.netdata_config)]
}

