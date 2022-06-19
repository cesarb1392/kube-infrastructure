locals {
  available_namespaces = {
    for k, v in local.applications :
    k => v.name if(v.enabled == true)
  }
}

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

output "modules_enabled" {
  value = keys(local.available_namespaces)
}
