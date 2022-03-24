# https://www.phillipsj.net/posts/k3s-enable-nfs-storage/
resource "kubernetes_persistent_volume_v1" "transmission_persistent_volume" {
  metadata {
    name = join("", [var.namespace, "-volume"])
    labels = {
      namespace = var.namespace
    }
  }
  spec {
    storage_class_name= "local-path"
    capacity = {
      storage = "50Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Delete"
    persistent_volume_source {
      nfs {
        path = "/ssd"
        #        server = "fastbanana2"
        server = "192.168.2.11/24"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "transmission_persistent_volume_claim" {
  metadata {
    name      = join("", [var.namespace, "-volume-claim"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "40Gi"
      }
    }
    volume_name = kubernetes_persistent_volume_v1.transmission_persistent_volume.metadata[0].name
  }
  depends_on = [kubernetes_persistent_volume_v1.transmission_persistent_volume]
}

resource "kubernetes_config_map_v1" "transmission_transmission_config_map" {
  metadata {
    name      = join("", [var.namespace, "-config-map"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  data = {
    LOCAL_NETWORK                         = "192.168.2.11/24"
    OPENVPN_OPTS                          = "--inactive 3600 --ping 10 --ping-exit 60"
    OPENVPN_PROVIDER                      = "NORDVPN"
    TRANSMISSION_DOWNLOAD_QUEUE_SIZE      = "4"
    TRANSMISSION_RATIO_LIMIT              = "2"
    TRANSMISSION_RATIO_LIMIT_ENABLED      = "true"
    TRANSMISSION_SPEED_LIMIT_DOWN         = "10000"
    TRANSMISSION_SPEED_LIMIT_DOWN_ENABLED = "true"
    TRANSMISSION_SPEED_LIMIT_UP           = "1000"
    TRANSMISSION_SPEED_LIMIT_UP_ENABLED   = "true"
    WEBPROXY_ENABLED                      = "false"
  }
}

resource "kubernetes_secret_v1" "transmission_secret_keys" {
  metadata {
    name      = join("", [var.namespace, "-secret"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  data = {
    username = var.K3S_OPENVPN_USERNAME
    password = var.K3S_OPENVPN_PASSWORD
  }
}

resource "kubernetes_deployment_v1" "transmission_deployment" {
  metadata {
    name      = join("", [var.namespace, "-deployment"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }

  spec {
    progress_deadline_seconds = 600
    replicas                  = 1
    revision_history_limit    = 10
    selector {
      match_labels = {
        app = var.namespace
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          app = var.namespace
        }
      }
      spec {
        restart_policy                   = "Always"
        termination_grace_period_seconds = 30
        container {
          name  = join("", [var.namespace, "-pod"])
          image = "haugene/transmission-openvpn"
        }
        volume {
          name = join("", [var.namespace, "-volume-claim"])
          persistent_volume_claim {
            #            claim_name = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.name
            claim_name = join("", [var.namespace, "-volume-claim"])
          }
        }
      }
    }
  }
}
