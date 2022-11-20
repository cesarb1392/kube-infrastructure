resource "kubernetes_persistent_volume" "this" {
  metadata {
    name = "${var.namespace}-pv"
  }
  spec {
    persistent_volume_reclaim_policy = "Delete"
    storage_class_name               = "local-path"
    access_modes                     = ["ReadWriteOnce"]
    capacity = {
      storage = "100Gi"
    }
    persistent_volume_source {
      host_path {
        path = "/tmp/ssd/${var.namespace}"
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
  metadata {
    name      = "${var.namespace}-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-path"
    resources {
      requests = {
        storage = "100Gi"
      }
    }
  }
  depends_on = [kubernetes_persistent_volume.this]
}
