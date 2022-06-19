resource "kubernetes_persistent_volume_claim_v1" "persistent_volume_claim_dnsmasq" {
  metadata {
    name      = join("", [var.namespace, "-volume-claim-dnsmasq"])
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
        storage = "100Mi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "persistent_volume_claim_data" {
  metadata {
    name      = join("", [var.namespace, "-volume-claim-data"])
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
