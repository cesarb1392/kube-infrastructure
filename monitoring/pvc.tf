resource "kubernetes_persistent_volume_claim_v1" "grafana_persistent_volume_claim" {
  metadata {
    name      = join("", [var.namespace, "-grafana-volume-claim"])
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

resource "kubernetes_persistent_volume_claim_v1" "prometheus_persistent_volume_claim" {
  metadata {
    name      = join("", [var.namespace, "-prometheus-volume-claim"])
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
        storage = "5Gi"
      }
    }
  }
}
