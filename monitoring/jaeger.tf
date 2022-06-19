
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
