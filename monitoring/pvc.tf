resource "kubernetes_persistent_volume_claim_v1" "grafana_persistent_volume_claim" {
  metadata {
    name      = "${var.namespace}-grafana"
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
    name      = "${var.namespace}-prometheus"

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

resource "kubernetes_persistent_volume_claim_v1" "netdata_persistent_volume_claim" {
  metadata {
    name      = "${var.namespace}-netdata"
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
