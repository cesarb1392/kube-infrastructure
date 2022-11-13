resource "kubernetes_deployment_v1" "wireshark" {
  metadata {
    name      = "wireshark"
    namespace = var.namespace
  }
  spec {
    replicas = "1"
    selector {
      match_labels = { "app" = "wireshark" }
    }
    template {
      metadata {
        labels = { "app" = "wireshark" }
      }
      spec {
        host_network = true
        security_context {
          run_as_group = "0"
          run_as_user  = "0"
        }
        container {
          name              = "wireshark"
          image             = "linuxserver/wireshark:latest"
          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
            seccomp_profile {
              type = "Unconfined"
            }
            privileged                 = true
            allow_privilege_escalation = true
            run_as_non_root            = false
            read_only_root_filesystem  = false
          }
          env {
            name  = "TZ"
            value = var.TZ
          }
          env {
            name  = "PUID"
            value = "1000"
          }

          env {
            name  = "PGID"
            value = "1000"
          }

        }
      }
    }
  }
}
