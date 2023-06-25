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
          name  = "transmission"
          image = "lscr.io/linuxserver/transmission"
          port {
            container_port = 9091
          }
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.transmission.metadata[0].name
              optional = false
            }
          }
          volume_mount {
            mount_path = "/data"
            name       = "data"
          }
        }
        volume {
          name = "localtime"
          host_path {
            path = "/etc/localtime"
          }
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }
  depends_on = [helm_release.pod_gateway]
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
          name  = "jackett"
          image = "lscr.io/linuxserver/jackett"
          port {
            container_port = 9117
          }
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.jackett.metadata[0].name
              optional = false
            }
          }
          volume_mount {
            mount_path = "/config"
            name       = "data"
            sub_path   = "configs/jackett"
          }
          volume_mount {
            mount_path = "/downloads"
            name       = "data"
            sub_path   = "downloads/jackett"
          }
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }
}