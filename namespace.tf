resource "kubernetes_namespace" "test_namespace" {
  metadata {
    name = local.namespace.test
    labels = {
      namespace = local.namespace.test
    }
  }
}

resource "kubernetes_namespace" "monitoring_namespace" {
  metadata {
    name = local.namespace.monitoring
    annotations = {
      name = local.namespace.monitoring
    }
    labels = {
      namespace = local.namespace.monitoring
    }
  }
}

