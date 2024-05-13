# RWO - ReadWriteOnce
# ROX - ReadOnlyMany
# RWX - ReadWriteMany
# RWOP - ReadWriteOncePod
resource "kubernetes_persistent_volume" "this" {
  metadata {
    name = "${var.namespace}-pv"
  }
  spec {
    persistent_volume_reclaim_policy = "Delete"
    storage_class_name               = "local-path"
    access_modes                     = ["ReadWriteOnce"]
    capacity = {
      storage = "350Gi"
    }
    persistent_volume_source {
      host_path {
        path = "/home/banana/torrente"
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["fastbanana"]
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "this" {
  wait_until_bound = false # otherwise pending forever since the pod isnt created yet

  metadata {
    name      = "${var.namespace}-transmission-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = kubernetes_persistent_volume.this.spec.0.storage_class_name
    resources {
      requests = {
        storage = "350Gi"
      }
    }
  }
}
