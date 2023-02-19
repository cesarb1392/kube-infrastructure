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

