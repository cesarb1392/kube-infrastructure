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
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/hostname"
                  operator = "In"
                  values   = ["slowbanana"]
                }
              }
            }
          }
        }
        restart_policy = "Always"
        container {
          name  = join("", [var.namespace, "-transmission-pod"])
          image = "haugene/transmission-openvpn"
          port {
            container_port = local.ports.transmission.internal
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
            mount_path = "/etc/localtime"
            name       = "localtime"
            read_only  = true
          }
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = var.persistent_volume_claim_name
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
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/hostname"
                  operator = "In"
                  values   = ["slowbanana"]
                }
              }
            }
          }
        }
        container {
          name  = join("", [var.namespace, "-jackett-pod"])
          image = "linuxserver/jackett"
          port {
            name           = "http"
            container_port = local.ports.jackett.internal
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
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }

}

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
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/hostname"
                  operator = "In"
                  values   = ["slowbanana"]
                }
              }
            }
          }
        }
        container {
          name  = join("", [var.namespace, "-radarr-pod"])
          image = "linuxserver/radarr"
          port {
            name           = "http"
            container_port = 7878
          }
          #          liveness_probe {
          #            failure_threshold     = 3
          #            initial_delay_seconds = 10
          #            period_seconds        = 2
          #            success_threshold     = 1
          #            tcp_socket {
          #              port = 7878
          #            }
          #            timeout_seconds = 2
          #          }
          #          readiness_probe {
          #            failure_threshold     = 3
          #            initial_delay_seconds = 10
          #            period_seconds        = 2
          #            success_threshold     = 2
          #            tcp_socket {
          #              port = 7878
          #            }
          #            timeout_seconds = 2
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
          resources {
            limits = {
              memory = "200Mi"
            }
          }
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
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }

}

resource "kubernetes_deployment_v1" "sonarr_deployment" {
  metadata {
    name      = join("", [var.namespace, "-sonarr-deployment"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "sonarr"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          app = "sonarr"
        }
      }
      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/hostname"
                  operator = "In"
                  values   = ["slowbanana"]
                }
              }
            }
          }
        }
        container {
          name  = join("", [var.namespace, "-sonarr-pod"])
          image = "linuxserver/sonarr"
          port {
            name           = "http"
            container_port = 8989
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
          resources {
            limits = {
              memory = "200Mi"
            }
          }
          volume_mount {
            mount_path = "/config"
            name       = "data"
            sub_path   = "configs/sonarr"
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
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }
}
