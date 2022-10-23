
#resource "kubernetes_deployment" "pi_hole" {
#  metadata {
#    namespace = var.namespace
#    name      = var.namespace
#  }
#
#  spec {
#    replicas = 1
#    selector {
#      match_labels = { "app" = var.namespace }
#    }
#    template {
#      metadata {
#        labels = { "app" = var.namespace }
#      }
#      spec {
#        dns_config {
#          nameservers = ["1.1.1.1"]
#        }
#
#        container {
#          name              = var.namespace
#          image             = "pihole/pihole"
#          image_pull_policy = "IfNotPresent"
#          env {
#            name  = "TZ"
#            value = var.TZ
#          }
#          env {
#            name  = "WEB_PORT"
#            value = 80
#          }
#          env {
#            name  = "PIHOLE_DNS_"
#            value = "8.8.8.8;8.8.4.4"
#          }
#          env {
#            name  = "WEBPASSWORD"
#            value = "PIHOLE_PASSWORD"
#          }
#          port {
#            container_port = 53
#            protocol       = "TCP"
#          }
#
#          port {
#            container_port = 53
#            protocol       = "UDP"
#          }
#          port {
#            container_port = 67
#            protocol       = "UDP"
#          }
#          port {
#            container_port = 80
#            protocol       = "TCP"
#          }
#
#          #          volume_mount {
#          #            mount_path = "/etc/pihole"
#          #            name       = "etc"
#          #          }
#          #          volume_mount {
#          #            mount_path = "/etc/dnsmasq.d"
#          #            name       = "dnsmasq"
#          #          }
#          #          volume_mount {
#          #            mount_path = "/etc/addn-hosts"
#          #            name       = "addn-hosts"
#          #          }
#          resources {
#            limits = {
#              memory = "1Gi"
#              cpu    = 1
#            }
#            requests = {
#              memory = "128Mi"
#              cpu    = "100m"
#            }
#          }
#        }
#        #        volume {
#        #          name = "etc"
#        #          host_path {
#        #            path = "/data/pihole/etc"
#        #            type = "Directory"
#        #          }
#        #        }
#        #        volume {
#        #          name = "dnsmasq"
#        #          host_path {
#        #            path = "/data/pihole/dnsmasq.d"
#        #            type = "Directory"
#        #          }
#        #        }
#        #        volume {
#        #          name = "addn-hosts"
#        #          host_path {
#        #            path = "/etc/addn-hosts"
#        #            type = "Directory"
#        #          }
#        #        }
#      }
#    }
#  }
#}
#
#resource "kubernetes_service" "pi_hole_web" {
#  metadata {
#    name      = var.namespace
#    namespace = var.namespace
#  }
#  spec {
#    port {
#      port        = 80
#      target_port = 80
#      protocol    = "TCP"
#    }
#    selector     = { "app" = var.namespace }
#    external_ips = ["192.168.178.231"]
#    type         = "LoadBalancer"
#  }
#}
#
#resource "kubernetes_service" "pi_hole_tcp" {
#  metadata {
#    name      = "${var.namespace}-tcp"
#    namespace = var.namespace
#  }
#  spec {
#    port {
#      port     = 53
#      protocol = "TCP"
#    }
#    selector     = { "app" = var.namespace }
#    external_ips = ["192.168.178.231"]
#    type         = "LoadBalancer"
#  }
#}
#resource "kubernetes_service" "pi_hole_udp" {
#  metadata {
#    name      = "${var.namespace}-udp"
#    namespace = var.namespace
#  }
#  spec {
#    port {
#      port     = 53
#      protocol = "UDP"
#    }
#    selector     = { "app" = var.namespace }
#    external_ips = ["192.168.178.231"]
#    type         = "LoadBalancer"
#  }
#}

#resource "kubernetes_ingress_v1" "pi_hole" {
#  metadata {
#    name        = var.namespace
#    namespace   = var.namespace
#    annotations = {
#      "nginx.ingress.kubernetes.io/ssl-redirect" = false
#      #      "nginx.ingress.kubernetes.io/rewrite-target" = "/admin"
#    }
#  }
#  spec {
#    ingress_class_name = "nginx"
#    rule {
#      host = "pihole.192.168.178.230.nip.io"
#      http {
#        path {
#          backend {
#            service {
#              name = kubernetes_service.pi_hole_web.metadata.0.name
#              port {
#                number = 80
#              }
#            }
#          }
#          #          path      = "/admin"
#          path      = "/"
#          path_type = "Prefix"
#        }
#      }
#    }
#  }
#}

#resource "kubernetes_service" "this" {
#  metadata {
#    name      = var.namespace
#    namespace = var.namespace
#  }
#  spec {
#    selector = {
#      app = var.namespace
#    }
#    session_affinity = "ClientIP"
#    port {
#      protocol    = "TCP"
#      port        = 80
#      target_port = 80
#      name        = "http"
#    }
#
#    port {
#      port        = 53
#      target_port = 53
#      name        = "dns"
#    }
#
#    type = "LoadBalancer"
#  }
#}


#resource "kubernetes_deployment" "pihole" {
#  metadata {
#    name = var.namespace
#    labels = {
#      app = var.namespace
#    }
#    namespace = var.namespace
#  }
#
#  spec {
#    replicas = 1
#    selector {
#      match_labels = {
#        app = var.namespace
#      }
#    }
#    template {
#      metadata {
#        labels = {
#          app = var.namespace
#        }
#      }
#      spec {
#        container {
#          image = "pihole/pihole:latest"
#          name  = var.namespace
#
#          port {
#            container_port = 80
#            name           = "http"
#            protocol       = "TCP"
#          }
#          port {
#            container_port = 443
#            name           = "https"
#            protocol       = "TCP"
#          }
#          port {
#            container_port = 53
#            name           = "dns-tcp"
#            protocol       = "TCP"
#          }
#          port {
#            container_port = 53
#            name           = "dns53"
#            protocol       = "UDP"
#          }
#          port {
#            container_port = 67
#            name           = "dns67"
#            protocol       = "UDP"
#          }
#          env {
#            name  = "TZ"
#            value = var.TZ
#          }
#          env {
#            name  = "WEBPASSWORD"
#            value = var.password
#          }
#          env {
#            name  = "DNSOne"
#            value = var.primary_dns
#          }
#          env {
#            name  = "DNSTwo"
#            value = var.secondary_dns
#          }
#        }
#      }
#    }
#  }
#}
#


#data "template_file" "pihole_values" {
#  template = yamlencode({
#    dnsmasq = {
#      customDnsEntries = ["address=/nas/192.168.178.10"]
#    }
#    customCnameEntries = ["cname=foo.nas,nas"]
#
#    persistentVolumeClaim = { enabled = false }
#
#    ingress = {
#      enabled          = true,
#      ingressClassName = "nginx"
#      path             = "/"
#      hosts            = ["pihole.192.168.178.230.nip.io"]
#    }
#
#    #    serviceWeb = {
#    #      loadBalancerIP = "192.168.178.230"
#    #      type           = "LoadBalancer"
#    #      annotations = {
#    #        "metallb.universe.tf/allow-shared-ip" = "pihole-svc"
#    #      }
#    #    }
#
#    serviceDns = {
#      loadBalancerIP = "192.168.178.231"
#      annotations = {
#        "metallb.universe.tf/allow-shared-ip" = "pihole-svc"
#      }
#      type = "LoadBalancer"
#    }
#
#    podDnsConfig = {
#      enabled     = true
#      policy      = "None"
#      nameservers = ["127.0.0.1", "1.1.1.1"]
#    }
#    adminPassword = "bananas"
#  })
#}
