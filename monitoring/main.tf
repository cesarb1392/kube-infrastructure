resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
    annotations = {
      name = var.namespace
    }
    labels = {
      namespace = var.namespace
    }
  }
}
