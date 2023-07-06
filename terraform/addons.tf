locals {
  cert_manager = {
    installCRDs = true
    prometheus = {
      enabled        = true
      servicemonitor = { enabled = true }
    }
  }
}


# Cert Manager
#https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  create_namespace = true
  namespace        = "cert-manager"
  version          = "v1.12.2"

  values = [yamlencode(local.cert_manager)] # [data.template_file.cert_manager.rendered]
}

#https://opensource.com/article/20/3/ssl-letsencrypt-k3s
#data "template_file" "cert_manager" {
#  template = <<YAML
#prometheus:
#  enabled: true
#  servicemonitor:
#    enabled: true
#installCRDs: true
#YAML
#}

# Local-path storage
resource "kubernetes_persistent_volume_claim" "this" {
  for_each = local.available_storage

  wait_until_bound = false
  metadata {
    name      = "${each.key}-pvc"
    namespace = each.key
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-path"
    resources {
      requests = {
        storage = each.value.storage
      }
    }
  }
  depends_on = [kubernetes_namespace.this]
}


# longhorn
resource "helm_release" "longhorn" {
  name             = "longhorn"
  chart            = "longhorn"
  repository       = "https://charts.longhorn.io"
  create_namespace = true
  namespace        = "longhorn"
  version          = "v1.4.2"

  values = []
}