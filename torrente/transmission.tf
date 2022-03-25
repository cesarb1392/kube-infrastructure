resource "kubernetes_config_map_v1" "transmission_transmission_config_map" {
  metadata {
    name      = join("", [var.namespace, "-transmission-config-map"])
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
  depends_on = [kubernetes_namespace.this]
}

resource "kubernetes_secret_v1" "transmission_secret_keys" {
  metadata {
    name      = join("", [var.namespace, "-transmission-secret"])
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
    name      = join("", [var.namespace, "-transmission-deployment"])
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
        app = "transmission"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          app = "transmission"
        }
      }
      spec {
        restart_policy                   = "Always"
        termination_grace_period_seconds = 30
        container {
          name  = join("", [var.namespace, "-transmission-pod"])
          image = "haugene/transmission-openvpn"

          port {
            container_port = 9091
          }
          liveness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 10
            period_seconds        = 2
            success_threshold     = 1
            tcp_socket {
              port = 9091
            }
            timeout_seconds = 2
          }
          readiness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 10
            period_seconds        = 2
            success_threshold     = 2
            tcp_socket {
              port = 9091
            }
            timeout_seconds = 2
          }

          env_from {
            config_map_ref {
              name     = kubernetes_config_map_v1.transmission_transmission_config_map.metadata[0].name
              optional = false
            }
          }
          env {
            name = "OPENVPN_USERNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.transmission_secret_keys.metadata[0].name
                key  = "username"
              }
            }
          }
          env {
            name = "OPENVPN_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.transmission_secret_keys.metadata[0].name
                key  = "password"
              }
            }
          }
          resources {
            limits = {
              memory = "200Mi"
            }
          }
          security_context {
            privileged                 = true
            allow_privilege_escalation = true
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
          volume_mount {
            mount_path = "/data"
            name       = "data"
          }
          volume_mount {
            mount_path = "/dev/net/tun"
            name       = "tunnel"
          }
          volume_mount {
            mount_path = "/etc/localtime"
            name       = "localtime"
            read_only  = true
          }
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.torrente_persistent_volume_claim.metadata[0].name
          }
        }
        volume {
          name = "tunnel"
          host_path {
            path = "/dev/net/tun"
          }
        }
        volume {
          name = "localtime"
          host_path {
            path = "/etc/localtime"
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.this]
}
