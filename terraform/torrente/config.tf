resource "kubernetes_config_map_v1" "config" {
  metadata {
    name      = "config"
    namespace = var.namespace
  }
  data = {
    TZ          = var.timezone
    USER        = var.user
    PASS        = var.pass
    PUID        = var.puid
    PGID        = var.pgid
    AUTO_UPDATE = true
  }
}

resource "kubernetes_persistent_volume_claim" "ssd" {
  wait_until_bound = true
  metadata {
    name      = "${var.namespace}-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "ssd-drive"
    resources {
      requests = {
        storage = "200Gi"
      }
    }
  }
}
