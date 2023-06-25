resource "kubernetes_config_map_v1" "transmission" {
  metadata {
    name      = "transmission"
    namespace = var.namespace
  }
  data = {
    TZ   = var.timezone
    USER = var.user
    PASS = var.pass
    PUID = var.puid
    PGID = var.pgid
  }
}

resource "kubernetes_config_map_v1" "jackett" {
  metadata {
    name      = "jackett"
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
