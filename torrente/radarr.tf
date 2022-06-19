resource "kubernetes_deployment_v1" "radarr_deployment" {
  metadata {
    name      = join("", [var.namespace, "-radarr-deployment"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "radarr"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          app = "radarr"
        }
      }
      spec {
        #        restart_policy = "Always"
        container {
          name  = join("", [var.namespace, "-radarr-pod"])
          image = "linuxserver/radarr"
          port {
            name           = "http"
            container_port = 7878
          }
          liveness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 10
            period_seconds        = 2
            success_threshold     = 1
            tcp_socket {
              port = 7878
            }
            timeout_seconds = 2
          }
          readiness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 10
            period_seconds        = 2
            success_threshold     = 2
            tcp_socket {
              port = 7878
            }
            timeout_seconds = 2
          }
          env {
            name  = "TZ"
            value = var.timezone
          }
          env {
            name  = "PUID"
            value = var.puid
          }
          env {
            name  = "PGID"
            value = var.pgid
          }
          #          resources {
          #            limits = {
          #              memory = "200Mi"
          #            }
          #          }
          volume_mount {
            mount_path = "/config"
            name       = "data"
            sub_path   = "configs/radarr"
          }
          volume_mount {
            mount_path = "/downloads"
            name       = "data"
            sub_path   = "downloads/transmission"
          }
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.metadata[0].name
          }
        }
      }
    }
  }

}
