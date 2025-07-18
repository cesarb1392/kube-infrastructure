resource "kubernetes_limit_range" "default" {
  for_each = tomap({
    for k, v in kubernetes_namespace.this : k => v
    if(v.metadata.0.name != "monitoring" && v.metadata.0.name != "torrente" && v.metadata.0.name != "falco")
  })

  metadata {
    labels    = each.value.metadata.0.labels
    name      = "${each.value.metadata.0.name}-limit"
    namespace = each.value.metadata.0.name
  }

  spec {
    limit {
      type = "Container"
      min = {
        cpu    = "50m"
        memory = "32Mi"
      }
      max = {
        cpu    = "1"
        memory = "1Gi"
      }
      default = {
        cpu    = "50m"
        memory = "32Mi"
      }
      default_request = {
        cpu    = "50m"
        memory = "32Mi"
      }
    }
    limit {
      type = "Pod"
      min = {
        cpu    = "50m"
        memory = "32Mi"
      }
      max = {
        cpu    = "1"
        memory = "1Gi"
      }
    }
  }
}
