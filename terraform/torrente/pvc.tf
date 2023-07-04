# RWO - ReadWriteOnce
# ROX - ReadOnlyMany
# RWX - ReadWriteMany
# RWOP - ReadWriteOncePod
resource "kubernetes_persistent_volume" "ssd" {
  metadata {
    name = "ssd-drive-pv"
  }
  spec {
    persistent_volume_reclaim_policy = "Delete"
    storage_class_name               = "ssd-drive"
    access_modes                     = ["ReadWriteMany"]
    capacity = {
      storage = "200Gi"
    }
    persistent_volume_source {
      host_path {
        path = "/home/banana/ssd"
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["slowbanana"]
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "ssd" {
  wait_until_bound = false
  metadata {
    name      = "${var.namespace}-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = kubernetes_persistent_volume.ssd.spec.0.storage_class_name
    resources {
      requests = {
        storage = "200Gi"
      }
    }
  }
}
