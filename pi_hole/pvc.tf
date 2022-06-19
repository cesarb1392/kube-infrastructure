resource "kubernetes_persistent_volume_claim_v1" "persistent_volume_claim" {
  metadata {
    name      = var.namespace
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
        storage = "1Gi"
      }
    }
  }
}
