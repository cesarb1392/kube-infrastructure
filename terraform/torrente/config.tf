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
