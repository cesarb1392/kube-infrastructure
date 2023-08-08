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
        #        security_context {
        #          run_as_user  = "0"
        #          run_as_group = "0"
        #          fs_group     = "0"
        #        }
        #        affinity {
        #          node_affinity {
        #            required_during_scheduling_ignored_during_execution {
        #              node_selector_term {
        #                match_expressions {
        #                  key      = "kubernetes.io/hostname"
        #                  operator = "In"
        #                  values   = ["slowbanana"]
        #                }
        #              }
        #            }
        #          }
        #        }
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
            name       = "data"
            sub_path   = "configs/transmission"
          }
          volume_mount {
            mount_path = "/downloads"
            name       = "data"
            sub_path   = "downloads"
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
              name     = kubernetes_config_map_v1.config.metadata[0].name
              optional = false
            }
          }
          volume_mount {
            mount_path = "/config"
            name       = "config"
            sub_path   = "configs/jackett"
          }
          #          volume_mount {
          #            mount_path = "/downloads"
          #            name       = "data"
          #            sub_path   = "downloads"
          #          }
        }
        volume {
          name = "config"
          persistent_volume_claim {
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }
  depends_on = [helm_release.pod_gateway]
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
          #          volume_mount {
          #            mount_path = "/downloads"
          #            name       = "data"
          #            sub_path   = "downloads"
          #          }
        }
        volume {
          name = "config"
          persistent_volume_claim {
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }
  depends_on = [helm_release.pod_gateway]
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
          name  = "radarr"
          image = "linuxserver/radarr"
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
            name       = "config"
            sub_path   = "configs/radarr"
          }
          #          volume_mount {
          #            mount_path = "/downloads"
          #            name       = "data"
          #            sub_path   = "downloads"
          #          }
        }
        volume {
          name = "config"
          persistent_volume_claim {
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }
  depends_on = [helm_release.pod_gateway]
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
          name  = "sonarr"
          image = "linuxserver/sonarr"
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
            name       = "config"
            sub_path   = "configs/sonarr"
          }
          #          volume_mount {
          #            mount_path = "/downloads"
          #            name       = "data"
          #            sub_path   = "downloads"
          #          }
        }
        volume {
          name = "config"
          persistent_volume_claim {
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }
  depends_on = [helm_release.pod_gateway]
}
