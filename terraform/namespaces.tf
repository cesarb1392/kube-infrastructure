resource "kubernetes_namespace" "this" {
  for_each = local.available_namespaces

  metadata {
    name = replace(each.value, "_", "-")
    labels = {
      namespace   = replace(each.value, "_", "-")
      application = replace(each.value, "_", "-")
      managed-by  = "Terraform"
    }
  }
}

output "modules_enabled" {
  value = keys(local.available_namespaces)
}
