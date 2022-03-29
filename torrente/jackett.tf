
resource "kubernetes_service_v1" "jackett_service" {
  metadata {
    name      = join("", [var.namespace, "-jackett-service"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
  spec {
    port {
      port = 9117
      name = "http"
    }
    selector = { app = "jackett" }
    type     = "ClusterIP"
  }
  depends_on = [kubernetes_namespace.this]
}

resource "kubernetes_deployment_v1" "jackett_deployment" {
  metadata {
    name      = join("", [var.namespace, "-jackett-deployment"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "jackett"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          app = "jackett"
        }
      }
      spec {
        #        restart_policy = "Always"
        container {
          name  = join("", [var.namespace, "-jackett-pod"])
          image = "linuxserver/jackett"
          port {
            name           = "http"
            container_port = 9117
          }
          #          liveness_probe {
          #            failure_threshold     = 5
          #            initial_delay_seconds = 10
          #            period_seconds        = 2
          #            success_threshold     = 1
          #            tcp_socket {
          #              port = 9117
          #            }
          #            timeout_seconds = 5
          #          }
          #          readiness_probe {
          #            failure_threshold     = 3
          #            initial_delay_seconds = 10
          #            period_seconds        = 2
          #            success_threshold     = 2
          #            tcp_socket {
          #              port = 9117
          #            }
          #            timeout_seconds = 5
          #          }
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
          env {
            name  = "AUTO_UPDATE"
            value = true
          }
          resources {
            limits = {
              memory = "200Mi"
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
            claim_name = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.metadata[0].name
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.this]
}
