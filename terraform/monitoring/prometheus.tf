#locals {
#  #  https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/values.yaml
#  prometheus_values = {
#    "alertmanager" = { "enabled" = false }
#
#    "serviceAccounts" = {
#      "alertmanager" = { "create" = false }
#    }
#    "server" = {
#      #          persistentVolume = {
#      #            size = "5Gi"
#      resources = {
#        requests = {
##          cpu    = "500m"
##          memory = "512Mi"
#          cpu    = "250m"
#          memory = "256Mi"
#        }
#      }
#    }
##    configmapReload = {
##      prometheus = {
##
##      }
##    }
#  }
#}
#
#resource "helm_release" "prometheus_server" {
#  count = var.available.prometheus ? 1 : 0
#
#  chart      = "prometheus"
#  name       = "prometheus"
#  repository = "https://prometheus-community.github.io/helm-charts"
#  namespace  = var.namespace
#
#  #  version = "15.10.1"
#
#  values = [
#    yamlencode(local.prometheus_values)
#  ]
#}


resource "helm_release" "prometheus_server" {
  count = var.available.prometheus ? 1 : 0

  chart      = "kube-prometheus-stack"
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = var.namespace

  #  version = "15.10.1"

  values = [file("${path.module}/prometheus_stack.yaml")]
}


