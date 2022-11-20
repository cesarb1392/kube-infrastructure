resource "kubernetes_secret_v1" "transmission_secret_keys" {
  metadata {
    name      = join("", [var.namespace, "-transmission-secret"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  data = {
    username = var.OPENVPN_USERNAME
    password = var.OPENVPN_PASSWORD
  }
}

resource "kubernetes_config_map_v1" "transmission_transmission_config_map" {
  metadata {
    name      = join("", [var.namespace, "-transmission-config-map"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  data = {
    LOCAL_NETWORK                         = "192.168.178.0/24"
    OPENVPN_OPTS                          = "--inactive 3600 --ping 10 --ping-exit 60"
    OPENVPN_PROVIDER                      = "NORDVPN"
    TRANSMISSION_DOWNLOAD_QUEUE_SIZE      = "6"
    TRANSMISSION_RATIO_LIMIT              = "4"
    TRANSMISSION_RATIO_LIMIT_ENABLED      = "true"
    TRANSMISSION_SPEED_LIMIT_DOWN         = "10000"
    TRANSMISSION_SPEED_LIMIT_DOWN_ENABLED = "true"
    TRANSMISSION_SPEED_LIMIT_UP           = "1000"
    TRANSMISSION_SPEED_LIMIT_UP_ENABLED   = "true"
    WEBPROXY_ENABLED                      = "false"
  }

}

