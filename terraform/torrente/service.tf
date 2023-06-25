resource "kubernetes_service_v1" "transmission" {
  metadata {
    name      = "transmission"
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
    annotations = {
      "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-svc"
    }
  }
  spec {
    load_balancer_ip = var.lan_ip
    type             = "LoadBalancer"
    port {
      port        = 9090
      target_port = 9091
      name        = "http"
    }
    selector = kubernetes_deployment_v1.transmission.spec.0.selector.0.match_labels
  }
}

resource "kubernetes_service_v1" "jackett" {
  metadata {
    name      = "jackett"
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
    annotations = {
      "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-svc"
    }
  }
  spec {
    load_balancer_ip = var.lan_ip
    type             = "LoadBalancer"
    port {
      port        = 9091
      target_port = 9117
      name        = "http"
    }
    selector = kubernetes_deployment_v1.jackett.spec.0.selector.0.match_labels
  }
}