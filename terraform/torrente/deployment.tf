#resource "kubernetes_deployment_v1" "transmission" {
#  metadata {
#    name      = join("", [var.namespace, "-transmission"])
#    namespace = var.namespace
#  }
#  spec {
#    selector {
#      match_labels = {
#        app = "transmission"
#      }
#    }
#    template {
#      metadata {
#        labels = {
#          app = "transmission"
#        }
#      }
#      spec {
#        container {
#          name  = join("", [var.namespace, "-transmission"])
#          image = "lscr.io/linuxserver/transmission"
#          port {
#            container_port = local.ports.transmission.internal
#          }
#          env_from {
#            config_map_ref {
#              name     = kubernetes_config_map_v1.transmission.metadata[0].name
#              optional = false
#            }
#          }
#          volume_mount {
#            mount_path = "/data"
#            name       = "data"
#          }
#        }
#        volume {
#          name = "localtime"
#          host_path {
#            path = "/etc/localtime"
#          }
#        }
#        volume {
#          name = "data"
#          persistent_volume_claim {
#            claim_name = var.persistent_volume_claim_name
#          }
#        }
#      }
#    }
#  }
#  depends_on = [helm_release.pod_gateway]
#}

