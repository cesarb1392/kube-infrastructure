resource "kubernetes_deployment" "pi_hole" {
  metadata {
    namespace = var.namespace
    name      = var.namespace
  }

  spec {
    replicas = 1
    selector {
      match_labels = { "app" = var.namespace }
    }
    template {
      metadata {
        labels = { "app" = var.namespace }
      }
      spec {
        dns_config {
          nameservers = ["1.1.1.1"]
        }

        container {
          name              = var.namespace
          image             = "pihole/pihole"
          image_pull_policy = "IfNotPresent"
          env {
            name  = "TZ"
            value = var.TZ
          }
          env {
            name  = "WEBPASSWORD"
            value = "var.PIHOLE_PASSWORD"
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

          #          volume_mount {
          #            mount_path = "/etc/pihole"
          #            name       = "etc"
          #          }
          #          volume_mount {
          #            mount_path = "/etc/dnsmasq.d"
          #            name       = "dnsmasq"
          #          }
          #          volume_mount {
          #            mount_path = "/etc/addn-hosts"
          #            name       = "addn-hosts"
          #          }
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
        #        volume {
        #          name = "etc"
        #          host_path {
        #            path = "/data/pihole/etc"
        #            type = "Directory"
        #          }
        #        }
        #        volume {
        #          name = "dnsmasq"
        #          host_path {
        #            path = "/data/pihole/dnsmasq.d"
        #            type = "Directory"
        #          }
        #        }
        #        volume {
        #          name = "addn-hosts"
        #          host_path {
        #            path = "/etc/addn-hosts"
        #            type = "Directory"
        #          }
        #        }
      }
    }
  }
}

resource "kubernetes_service" "pi_hole" {
  metadata {
    name      = var.namespace
    namespace = var.namespace
  }
  spec {
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
      name        = "http"
    }
    port {
      port        = 53
      target_port = 53
      protocol    = "TCP"
      name        = "dns-tcp"
    }
    port {
      port        = 53
      target_port = 53
      protocol    = "UDP"
      name        = "dns-udp"
    }
    port {
      port        = 67
      target_port = 67
      protocol    = "UDP"
      name        = "dhcp"
    }
    selector = { "app" = var.namespace }
  }
}

resource "kubernetes_ingress_v1" "pi_hole" {
  metadata {
    name        = var.namespace
    namespace   = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"   = false
#      "nginx.ingress.kubernetes.io/rewrite-target" = "/admin"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "pihole.192.168.178.230.nip.io"
      http {
        path {
          backend {
            service {
              name = kubernetes_service.pi_hole.metadata.0.name
              port {
                number = 80
              }
            }
          }
#          path      = "/admin"
          path      = "/"
          path_type = "Prefix"
        }
      }
    }
  }
}
