# https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/values.yaml
resource "helm_release" "prometheus" {
  chart      = "prometheus"
  name       = var.namespace
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"

  #  set {
  #    name  = "podSecurityPolicy\\.enabled"
  #    value = true
  #  }
  #  set {
  #    name = "server\\.resources"
  #    value = yamlencode({
  #      limits = {
  #        cpu    = "200m"
  #        memory = "50Mi"
  #      }
  #      requests = {
  #        cpu    = "100m"
  #        memory = "30Mi"
  #      }
  #    })
  #  }
  values = [
    data.template_file.prometheus_values.rendered
  ]
}

data "template_file" "prometheus_values" {
  template = file("${path.module}/prometheus_helm_values.yaml")
}

#https://github.com/jaegertracing/helm-charts/blob/main/charts/jaeger/values.yaml
#resource "helm_release" "jaeger" {
#  chart      = "jaeger-operator"
#  name       = "jaeger-operator"
#  repository = "https://jaegertracing.github.io/helm-charts"
#  namespace  = var.namespace
#}

#resource "kubernetes_manifest" "jaeger_instance" {
#  manifest = {
#    apiVersion = "jaegertracing.io/v1"
#    kind       = "Jaeger"
#    metadata   = {
#      name      = "jaeger"
#      namespace = var.namespace
#    }
#  }
#  depends_on = [
#    helm_release.jaeger
#  ]
#}
