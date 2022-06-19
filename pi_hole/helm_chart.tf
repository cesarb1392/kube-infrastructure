#resource "helm_release" "pihole" {
#  chart      = "pihole"
#  name       = "mojo2600"
#  repository = "https://mojo2600.github.io/pihole-kubernetes"
#
#  namespace       = var.namespace
#  timeout         = 120
#  cleanup_on_fail = true
#  force_update    = true
#
#  values = [
#    data.template_file.pihole_values.rendered
#  ]
#  depends_on = [data.template_file.pihole_values]
#}
#
#data "template_file" "pihole_values" {
#  template = file("${path.module}/values.yaml")
#  vars = {
#    PVC      = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.metadata[0].name
#    PASSWORD = var.K3S_PIHOLE_PASSWORD # changes to existingSecret
#  }
#}
##
##resource "kubernetes_secret_v1" "pihole_secret_keys" {
##  metadata {
##    name      = join("", [var.namespace, "-pi-hole-secret"])
##    namespace = var.namespace
##    labels = {
##      namespace = var.namespace
##    }
##  }
##  data = {
##    password = var.K3S_PIHOLE_PASSWORD
##  }
##}
#
#
##https://greg.jeanmart.me/2020/04/13/self-host-pi-hole-on-kubernetes-and-block-ad/
#resource "kubernetes_manifest" "pi_hole_ingress" {
#  manifest = {
#    apiVersion = "traefik.containo.us/v1alpha1"
#    kind       = "IngressRoute"
#    metadata = {
#      name      = "pihole-ingress"
#      namespace = var.namespace
#    }
#    spec = {
#      entryPoints = ["websecure"]
#      routes = [
#        {
#          match = "Host(`pihole.192.168.2.20.nip.io`)"
#          kind  = "Rule"
#          services = [
#            {
#              name = "mojo2600-pihole-web"
#              port = 80
#            }
#          ]
#        }
#      ]
#    }
#  }
#
#}
#
#resource "kubernetes_service_v1" "pi_hole_service_tcp" {
#  metadata {
#    name      = join("", [var.namespace, "-pi-hole-service-tcp"])
#    namespace = var.namespace
#    labels = {
#      namespace = var.namespace
#    }
#  }
#  spec {
#    port {
#      protocol = "TCP"
#      port     = 80
#      name     = "http"
#    }
#    port {
#      protocol = "TCP"
#      port     = 443
#      name     = "https"
#    }
#    port {
#      protocol = "TCP"
#      port     = 53
#      name     = "dns-tcp"
#    }
#    selector = { app = "pihole" }
#    type     = "LoadBalancer"
#  }
#
#}
#
#resource "kubernetes_service_v1" "pi_hole_service_udp" {
#  metadata {
#    name      = join("", [var.namespace, "-pi-hole-service-udp"])
#    namespace = var.namespace
#    labels = {
#      namespace = var.namespace
#    }
#  }
#  spec {
#    port {
#      protocol = "UDP"
#      port     = 53
#      name     = "dns-udp"
#    }
#    port {
#      protocol = "UDP"
#      port     = 67
#      name     = "dhcp-udp"
#    }
#
#    selector = { app = "pihole" }
#    type     = "LoadBalancer"
#  }
#
#}
#
#resource "kubernetes_secret_v1" "pihole_secret_keys" {
#  metadata {
#    name      = join("", [var.namespace, "-pi-hole-secret"])
#    namespace = var.namespace
#    labels = {
#      namespace = var.namespace
#    }
#  }
#  data = {
#    password = var.K3S_PIHOLE_PASSWORD
#  }
#}
