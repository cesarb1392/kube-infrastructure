locals {
  # https://github.com/grafana/helm-charts/blob/main/charts/promtail/values.yaml
  promtail_values = {
    # Bare in mind, the ./configuration/coredns.conf file which holds IP to DNS
    # kubectl get cm coredns -n kube-system -o yaml
    config = {
      clients = [{ "url" = "http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push" }]
    }
  }
}

resource "helm_release" "promtail" {
  count = var.available.promtail ? 1 : 0

  chart      = "promtail"
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = var.namespace
  version    = "6.2.0"
  values     = [yamlencode(local.promtail_values)]
}
