resource "kubernetes_service_v1" "transmission_service" {
  metadata {
    name      = join("", [var.namespace, "-transmission-service"])
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
    annotations = {
      "metallb.universe.tf/allow-shared-ip" = "torrente-svc"
    }
  }
  spec {
    load_balancer_ip = var.host_ip
    port {
      port        = local.ports.transmission.external
      target_port = local.ports.transmission.internal
      name        = "http"
    }
    selector = { app = "transmission" }
    type     = "LoadBalancer"
  }

}

resource "kubernetes_service_v1" "jackett_service" {
  metadata {
    name      = join("", [var.namespace, "-jackett-service"])
    namespace = var.namespace
    annotations = {
      "metallb.universe.tf/allow-shared-ip" = "torrente-svc"
    }
  }
  spec {
    load_balancer_ip = var.host_ip
    port {
      port        = local.ports.jackett.external
      target_port = local.ports.jackett.internal
      name        = "http"
    }
    selector = { app = "jackett" }
    type     = "LoadBalancer"
  }

}