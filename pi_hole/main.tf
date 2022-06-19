resource "kubernetes_deployment" "pi_hole" {
  metadata {
    namespace = var.namespace
    name      = var.namespace
  }

  spec {
    replicas = 1
    selector {
      match_labels = { "app" = "pi-hole" }
    }
    template {
      metadata {
        labels = { "app" = "pi-hole" }
      }
      spec {
        host_network = true
        dns_policy   = "None"
        dns_config {
          nameservers = ["1.1.1.1"]
        }

        container {
          name              = var.namespace
          image             = "pihole/pihole"
          image_pull_policy = "IfNotPresent"

#          security_context {
#            privileged                 = true
#            allow_privilege_escalation = true
#            capabilities {
#              add = ["NET_ADMIN"]
#            }
#          }
          env {
            name  = "TZ"
            value = "Europe/Amsterdam"
          }
          env {
            name  = "WEBPASSWORD"
            value = var.K3S_PIHOLE_PASSWORD
          }
          port {
            container_port = 53
            protocol       = "TCP"
          }
          port {
            container_port = 53
            protocol       = "UDP"
          }
          port {
            container_port = 67
            protocol       = "UDP"
          }
          port {
            container_port = 80
            protocol       = "TCP"
          }
          port {
            container_port = 443
            protocol       = "TCP"
          }

          volume_mount {
            mount_path = "/etc/pihole"
            name       = "data"
          }
          volume_mount {
            mount_path = "/etc/dnsmasq.d"
            name       = "dnsmasq"
          }
          resources {
            limits = {
              memory = "1Gi"
              cpu    = 1
            }
            requests = {
              memory = "128Mi"
              cpu    = "100m"
            }
          }
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.persistent_volume_claim_data.metadata[0].name
          }
        }
        volume {
          name = "dnsmasq"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.persistent_volume_claim_dnsmasq.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "pi_hole" {
  metadata {
    name      = "pihole"
    namespace = var.namespace
  }
  spec {
    port {
      port = 80
      target_port = 80
      protocol = "TCP"
      name = "http"
    }
    port {
      port = 443
      target_port = 443
      protocol = "TCP"
      name = "https"
    }
    port {
      port = 53
      target_port = 53
      protocol = "TCP"
      name = "dns-tcp"
    }
    port {
      port = 53
      target_port = 53
      protocol = "UDP"
      name = "dns-udp"
    }
    port {
      port = 67
      target_port = 67
      protocol = "UDP"
      name = "dhcp"
    }
    selector = { "app" = "pi-hole" }

#    type= "LoadBalancer"
#    external_traffic_policy = "Local"
    external_ips = ["192.168.2.10","192.168.2.11", "192.168.2.12", "192.168.2.20"]
  }
}

#resource "kubernetes_pod" "pi_hole" {
#  metadata {
#    namespace = var.namespace
#    name      = var.namespace
#    labels = { "app" = "pi-hole" }
#  }
#  spec {
#    host_network = true
#    dns_policy   = "None"
#    dns_config {
#      nameservers = ["1.1.1.1"]
#    }
#
#    container {
#      name              = var.namespace
#      image             = "pihole/pihole"
#      image_pull_policy = "IfNotPresent"
#
#      security_context {
#        privileged                 = true
#        allow_privilege_escalation = true
#        capabilities {
#          add = ["NET_ADMIN"]
#        }
#      }
#      env {
#        name  = "TZ"
#        value = "Europe/Amsterdam"
#      }
#      env {
#        name  = "WEBPASSWORD"
#        value = var.K3S_PIHOLE_PASSWORD
#      }
#      port {
#        container_port = 53
#        protocol       = "TCP"
#      }
#      port {
#        container_port = 53
#        protocol       = "UDP"
#      }
#      port {
#        container_port = 67
#        protocol       = "UDP"
#      }
#      port {
#        container_port = 80
#        protocol       = "TCP"
#      }
#      port {
#        container_port = 443
#        protocol       = "TCP"
#      }
#
#      volume_mount {
#        mount_path = "/etc/pihole"
#        name       = "data"
#      }
#      volume_mount {
#        mount_path = "/etc/dnsmasq.d"
#        name       = "dnsmasq"
#      }
#      resources {
#        limits = {
#          memory = "1Gi"
#          cpu    = 1
#        }
#        requests = {
#          memory = "128Mi"
#          cpu    = "100m"
#        }
#      }
#    }
#
#    volume {
#      name = "data"
#      persistent_volume_claim {
#        claim_name = kubernetes_persistent_volume_claim_v1.persistent_volume_claim_data.metadata[0].name
#      }
#    }
#    volume {
#      name = "dnsmasq"
#      persistent_volume_claim {
#        claim_name = kubernetes_persistent_volume_claim_v1.persistent_volume_claim_dnsmasq.metadata[0].name
#      }
#    }
#  }
#}
