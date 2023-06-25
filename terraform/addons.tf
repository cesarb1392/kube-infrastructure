resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  create_namespace = true
  repository       = "https://charts.jetstack.io"
  namespace        = "cert-manager"
  version          = "v1.12.2"

  values = [data.template_file.cert_manager.rendered]

}
data "template_file" "cert_manager" {
  template = <<YAML
prometheus:
  enabled: false
installCRDs: true
YAML
}


#resource "kubernetes_persistent_volume" "this" {
#  for_each = local.available_storage
#
#  metadata {
#    name = "${each.key}-pv"
#  }
#  spec {
#    persistent_volume_reclaim_policy = "Delete"
#    storage_class_name               = "local-path"
#    access_modes                     = ["ReadWriteOnce"]
#    capacity = {
#      storage = each.value.storage
#    }
#    persistent_volume_source {
#      host_path {
#        path = "/tmp/ssd/${each.key}"
#      }
#    }
#    node_affinity {
#      required {
#        node_selector_term {
#          match_expressions {
#            key      = "kubernetes.io/hostname"
#            operator = "In"
#            values   = ["slowbanana"]
#          }
#        }
#      }
#    }
#  }
#
#}

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
