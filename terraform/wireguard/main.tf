resource "kubernetes_service" "this" {
  metadata {
    name      = var.target_service
    namespace = var.namespace
  }
  spec {
    port {
      port = var.ingress_port
    }
    selector = { "app" = var.namespace }
  }
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.namespace
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app" = var.namespace }
    }
    template {
      metadata {
        labels = { "app" = var.namespace }
      }
      spec {
        #        security_context {
        #          sysctl {
        #            name  = "net.ipv4.conf.all.src_valid_mark"
        #            value = 1
        #          }
        #        }
        container {
          name  = var.namespace
          image = "lscr.io/linuxserver/wireguard:latest"
          port {
            protocol       = "UDP"
            container_port = var.ingress_port
          }

          security_context {
            capabilities {
              add = ["NET_ADMIN", "SYS_MODULE"]
            }
            privileged = true
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.env_vars.metadata.0.name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_secret" "env_vars" {
  metadata {
    name      = "env-vars"
    namespace = var.namespace
  }
  data = tomap(
    {
      PUID       = 1000
      PGID       = 1000
      TZ         = var.TZ
      SERVERURL  = "${var.target_service}.${var.CF_ZONE_NAME}"
      SERVERPORT = var.ingress_port
      PEERS      = 1
      PEERDNS    = "auto"
      ALLOWEDIPS = "0.0.0.0/0"
      LOG_CONFS  = true
    }
  )
  type = "Opaque"
}