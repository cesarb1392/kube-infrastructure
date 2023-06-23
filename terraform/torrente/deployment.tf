resource "kubernetes_deployment_v1" "transmission" {
  metadata {
    name      = join("", [var.namespace, "-transmission"])
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
          name  = join("", [var.namespace, "-transmission"])
          image = "lscr.io/linuxserver/transmission"
          port {
            container_port = local.ports.transmission.internal
          }
          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.transmission.metadata[0].name
              optional = false
            }
          }
          #          liveness_probe {
          #            failure_threshold     = 3
          #            initial_delay_seconds = 10
          #            period_seconds        = 2
          #            success_threshold     = 2
          #            exec {
          #              command = ["curl","ifconfig.me"]
          #            }
          #            timeout_seconds = 2
          #          }
          volume_mount {
            mount_path = "/data"
            name       = "data"
          }
        }

        container {
          name  = join("", [var.namespace, "-vpn-transmission"])
          image = "ghcr.io/bubuntux/nordlynx"
          port {
            container_port = local.ports.transmission.internal
          }
          env_from {
            secret_ref {
              name     = kubernetes_secret_v1.vpn.metadata.0.name
              optional = false
            }
          }
          security_context {
            privileged                 = true
            allow_privilege_escalation = true
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
          resources {
            requests = local.vpn_pod_limits.requests
            limits   = local.vpn_pod_limits.limits
          }
          volume_mount {
            mount_path = "/etc/localtime"
            name       = "localtime"
            read_only  = true
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
}

resource "kubernetes_deployment_v1" "jackett" {
  metadata {
    name      = join("", [var.namespace, "-jackett"])
    namespace = var.namespace
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
          name  = join("", [var.namespace, "-jackett"])
          image = "lscr.io/linuxserver/jackett"

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

        container {
          name  = join("", [var.namespace, "-vpn-jackket"])
          image = "ghcr.io/bubuntux/nordlynx"
          port {
            container_port = local.ports.jackett.internal
          }
          env_from {
            secret_ref {
              name     = kubernetes_secret_v1.vpn.metadata.0.name
              optional = false
            }
          }
          security_context {
            privileged                 = true
            allow_privilege_escalation = true
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
          resources {
            requests = local.vpn_pod_limits.requests
            limits   = local.vpn_pod_limits.limits
          }
          volume_mount {
            mount_path = "/etc/localtime"
            name       = "localtime"
            read_only  = true
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
}
