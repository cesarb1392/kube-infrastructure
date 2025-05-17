
# Local-path storage
resource "kubernetes_persistent_volume_claim" "this" {
  for_each = local.available_storage

  wait_until_bound = false
  metadata {
    name      = "${each.key}-pvc"
    namespace = each.key
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    # storage_class_name = "local-path"
    resources {
      requests = {
        storage = each.value.storage
      }
    }
  }
  depends_on = [kubernetes_namespace.this]
}


# longhorn
#resource "helm_release" "longhorn" {
#  name             = "longhorn"
#  chart            = "longhorn"
#  repository       = "https://charts.longhorn.io"
#  create_namespace = true
#  namespace        = "longhorn"
#  version          = "v1.4.2"
#
#  values = []
#}
