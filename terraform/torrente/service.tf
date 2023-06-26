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
      target_port = kubernetes_deployment_v1.transmission.spec.0.template.0.spec.0.container.0.port.0.container_port
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
      target_port = kubernetes_deployment_v1.jackett.spec.0.template.0.spec.0.container.0.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.jackett.spec.0.selector.0.match_labels
  }
}

resource "kubernetes_service_v1" "prowlarr" {
  metadata {
    name      = "prowlarr"
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
      port        = 9092
      target_port = kubernetes_deployment_v1.prowlarr.spec.0.template.0.spec.0.container.0.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.prowlarr.spec.0.selector.0.match_labels
  }
}

resource "kubernetes_service_v1" "sonarr" {
  metadata {
    name      = "sonarr"
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
      port        = 9093
      target_port = kubernetes_deployment_v1.sonarr.spec.0.template.0.spec.0.container.0.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.sonarr.spec.0.selector.0.match_labels
  }
}

resource "kubernetes_service_v1" "radarr" {
  metadata {
    name      = "radarr"
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
      port        = 9094
      target_port = kubernetes_deployment_v1.radarr.spec.0.template.0.spec.0.container.0.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.radarr.spec.0.selector.0.match_labels
  }
}