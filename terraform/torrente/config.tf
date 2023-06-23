resource "kubernetes_secret_v1" "vpn" {
  metadata {
    name      = join("", [var.namespace, "-vpn-secret"])
    namespace = var.namespace
  }
  data = {
    #    https://github.com/bubuntux/nordlynx#environment
    PRIVATE_KEY = var.PRIVATE_KEY
    NET_LOCAL   = "192.168.178.0/24"
    TZ          = var.timezone
    ALLOWED_IPS = "0.0.0.0/0"
    DNS         = "208.67.222.222,1.1.1.1"
    END_POINT   = "${local.vpc_server[0].hostname}:51820"
    PUBLIC_KEY  = local.vpc_server[0].technologies[5].metadata[0].value
    RECONNECT   = 120
  }
}

resource "kubernetes_config_map_v1" "transmission" {
  metadata {
    name      = join("", [var.namespace, "-transmission"])
    namespace = var.namespace
  }
  data = {
    #    https://docs.linuxserver.io/images/docker-transmission#environment-variables-e
    TZ   = var.timezone
    USER = "banana"
    PASS = "banana"
    PUID = var.puid
    PGID = var.pgid
  }
}

resource "kubernetes_config_map_v1" "jackett" {
  metadata {
    name      = join("", [var.namespace, "-jackett"])
    namespace = var.namespace
  }
  data = {
    #    https://docs.linuxserver.io/images/docker-jackett#environment-variables-e
    TZ          = var.timezone
    USER        = "banana"
    PASS        = "banana"
    PUID        = var.puid
    PGID        = var.pgid
    AUTO_UPDATE = true
  }
}
