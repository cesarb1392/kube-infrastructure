resource "kubernetes_persistent_volume" "this" {
  for_each = local.available_storage

  metadata {
    name = "${each.key}-pv"
  }
  spec {
    persistent_volume_reclaim_policy = "Delete"
    storage_class_name               = "local-path"
    access_modes                     = ["ReadWriteOnce"]
    capacity = {
      storage = each.value.storage
    }
    persistent_volume_source {
      host_path {
        path = "/tmp/ssd/${each.key}"
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["fastbanana2"]
          }
        }
      }
    }
  }
}


resource "kubernetes_persistent_volume_claim" "this" {
  for_each = local.available_storage

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
  depends_on = [kubernetes_persistent_volume.this]
}
