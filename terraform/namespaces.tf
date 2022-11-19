resource "kubernetes_namespace" "this" {
  for_each = local.available_namespaces

  metadata {
    name = each.value
    labels = {
      namespace   = each.value
      application = each.value
      managed-by  = "Terraform"
    }
  }
}


resource "kubernetes_limit_range" "default" {
  for_each = kubernetes_namespace.this

  metadata {
    labels    = each.value.metadata.0.labels
    name      = "${each.value.metadata.0.name}-limit"
    namespace = each.value.metadata.0.name
  }

  spec {
    limit {
      type = "Container"
      min = {
        cpu    = "25m"
        memory = "32Mi"
      }
      max = {
        cpu    = "1"
        memory = "1Gi"
      }
      default = {
        cpu    = "250m"
        memory = "256Mi"
      }
      default_request = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
    limit {
      type = "Pod"
      min = {
        cpu    = "25m"
        memory = "32Mi"
      }
      max = {
        cpu    = "1"
        memory = "1Gi"
      }
    }
  }

  depends_on = [kubernetes_namespace.this]
}
