resource "kubernetes_deployment_v1" "transmission" {
  metadata {
    name      = "transmission"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "transmission"
      }
    }
    template {
      metadata {
        labels = {
          app = "transmission"
        }
      }
      spec {
        container {
          name  = "nordvpn-init"
          image = "ghcr.io/bubuntux/nordlynx:2023-06-01"

          env {
            name  = "PRIVATE_KEY"
            value = var.TOKEN
          }

          env {
            name  = "TZ"
            value = "Europe/Madrid"
          }
          env {
            name  = "NET_LOCAL"
            value = "192.168.178.0/24"
          }
          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
        }
        container {
          name  = "transmission"
          image = "lscr.io/linuxserver/transmission"
          port {
            container_port = 9091
          }
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.config.metadata[0].name
              optional = false
            }
          }
          volume_mount {
            mount_path = "/config"
            name       = "torrente"
            sub_path   = "configs/transmission"
          }
          volume_mount {
            mount_path = "/downloads"
            name       = "torrente"
            sub_path   = "downloads"
          }
        }

        volume {
          name = "torrente"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "jackett" {
  metadata {
    name      = "jackett"
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  spec {
    selector {
      match_labels = {
        app = "jackett"
      }
    }
    template {
      metadata {
        labels = {
          app = "jackett"
        }
      }
      spec {
        container {
          name  = "nordvpn-init"
          image = "ghcr.io/bubuntux/nordlynx:2023-06-01"

          env {
            name  = "PRIVATE_KEY"
            value = var.TOKEN
          }

          env {
            name  = "TZ"
            value = "Europe/Madrid"
          }
          env {
            name  = "NET_LOCAL"
            value = "192.168.178.0/24"
          }
          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
        }
        container {
          name  = "jackett"
          image = "lscr.io/linuxserver/jackett:0.22.1014"
          port {
            container_port = 9117
          }
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.config.metadata[0].name
              optional = false
            }
          }
          volume_mount {
            mount_path = "/config"
            name       = "torrente"
            sub_path   = "configs/jackett"
          }
          volume_mount {
            mount_path = "/downloads"
            name       = "torrente"
            sub_path   = "downloads"
          }
        }
        volume {
          name = "torrente"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "prowlarr" {
  metadata {
    name      = "prowlarr"
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  spec {
    selector {
      match_labels = {
        app = "prowlarr"
      }
    }
    template {
      metadata {
        labels = {
          app = "prowlarr"
        }
      }
      spec {
        container {
          name  = "nordvpn-init"
          image = "ghcr.io/bubuntux/nordlynx:2023-06-01"

          env {
            name  = "PRIVATE_KEY"
            value = var.TOKEN
          }

          env {
            name  = "TZ"
            value = "Europe/Madrid"
          }
          env {
            name  = "NET_LOCAL"
            value = "192.168.178.0/24"
          }
          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
        }
        container {
          name  = "prowlarr"
          image = "lscr.io/linuxserver/prowlarr"
          port {
            container_port = 9696
          }
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.config.metadata[0].name
              optional = false
            }
          }
          volume_mount {
            mount_path = "/config"
            name       = "config"
            sub_path   = "configs/prowlarr"
          }
        }
        volume {
          name = "config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "radarr" {
  metadata {
    name      = "radarr"
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  spec {
    selector {
      match_labels = {
        app = "radarr"
      }
    }
    template {
      metadata {
        labels = {
          app = "radarr"
        }
      }
      spec {
        container {
          name  = "nordvpn-init"
          image = "ghcr.io/bubuntux/nordlynx:2023-06-01"

          env {
            name  = "PRIVATE_KEY"
            value = var.TOKEN
          }

          env {
            name  = "TZ"
            value = "Europe/Madrid"
          }
          env {
            name  = "NET_LOCAL"
            value = "192.168.178.0/24"
          }
          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
        }
        container {
          name  = "radarr"
          image = "lscr.io/linuxserver/radarr"
          port {
            container_port = 7878
          }
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.config.metadata[0].name
              optional = false
            }
          }
          volume_mount {
            mount_path = "/config"
            name       = "torrente"
            sub_path   = "configs/radarr"
          }
          volume_mount {
            mount_path = "/downloads"
            name       = "torrente"
            sub_path   = "downloads"
          }
        }
        volume {
          name = "torrente"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "sonarr" {
  metadata {
    name      = "sonarr"
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  spec {
    selector {
      match_labels = {
        app = "sonarr"
      }
    }
    template {
      metadata {
        labels = {
          app = "sonarr"
        }
      }
      spec {
        container {
          name  = "nordvpn-init"
          image = "ghcr.io/bubuntux/nordlynx:2023-06-01"

          env {
            name  = "PRIVATE_KEY"
            value = var.TOKEN
          }

          env {
            name  = "TZ"
            value = "Europe/Madrid"
          }
          env {
            name  = "NET_LOCAL"
            value = "192.168.178.0/24"
          }
          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
        }
        container {
          name  = "sonarr"
          image = "lscr.io/linuxserver/sonarr"
          port {
            container_port = 8989
          }
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.config.metadata[0].name
              optional = false
            }
          }
          volume_mount {
            mount_path = "/config"
            name       = "torrente"
            sub_path   = "configs/sonarr"
          }
          volume_mount {
            mount_path = "/downloads"
            name       = "torrente"
            sub_path   = "downloads"
          }
        }
        volume {
          name = "torrente"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
          }
        }
      }
    }
  }
}


resource "kubernetes_deployment_v1" "filebrowser" {
  metadata {
    name      = "filebrowser"
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  spec {
    selector {
      match_labels = {
        app = "filebrowser"
      }
    }
    template {
      metadata {
        labels = {
          app = "filebrowser"
        }
      }
      spec {
        container {
          name  = "filebrowser"
          image = "filebrowser/filebrowser:s6"
          port {
            container_port = 80
          }
          env {
            name  = "FB_AUTH_METHOD"
            value = "none"
          }
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.config.metadata[0].name
              optional = false
            }
          }
          volume_mount {
            mount_path = "/config"
            name       = "torrente"
            sub_path   = "configs/filebrowser"
          }
          volume_mount {
            mount_path = "/database"
            name       = "torrente"
            sub_path   = "configs/filebrowser/database"
          }
          volume_mount {
            mount_path = "/srv"
            name       = "torrente"
            sub_path   = "filebrowser"
          }
        }
        volume {
          name = "torrente"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
          }
        }
      }
    }
  }
}
