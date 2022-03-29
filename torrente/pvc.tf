#resource "kubernetes_persistent_volume_v1" "torrente_persistent_volume" {
#  metadata {
#    name = join("", [var.namespace, "-volume"])
#    labels = {
#      namespace = var.namespace
#    }
#  }
#  spec {
#    storage_class_name = "nfs"
#    capacity = {
#      storage = "50Gi"
#    }
#    access_modes                     = ["ReadWriteMany"]
#    persistent_volume_reclaim_policy = "Delete" # "Retain"
##    persistent_volume_source {
##      nfs {
##        path   = "/var/nfs"
##        server = "fastbanana2"
##        #        server = "192.168.2.11/24"
##      }
##    }
#    persistent_volume_source {}
#  }
#}

resource "kubernetes_persistent_volume_claim_v1" "persistent_volume_claim" {
  metadata {
    name      = join("", [var.namespace, "-volume-claim"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  spec {
    storage_class_name = "nfs"
    access_modes       = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "40Gi"
      }
    }
    #    volume_name = kubernetes_persistent_volume_v1.torrente_persistent_volume.metadata[0].name
  }
  depends_on = [kubernetes_namespace.this]
}
