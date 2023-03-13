locals {
  # https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
  prometheus_values = {
    defaultRules = {
      rules = { alertmanager = false }
    }
    "alertmanager" = { "enabled" = false }


    "server" = {
      #          persistentVolume = {
      #            size = "5Gi"
      #      resources = {
      #        requests = {
      #          cpu    = "250m"
      #          memory = "256Mi"
      #        }
      #      }
    }
    #    configmapReload = {
    #      prometheus = {
    #
    #      }
    #    }
  }
}

resource "helm_release" "prometheus_server" {
  count = var.available.prometheus ? 1 : 0

  chart      = "kube-prometheus-stack"
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = var.namespace

  values = [file("${path.module}/prometheus_stack.yaml")]
}
