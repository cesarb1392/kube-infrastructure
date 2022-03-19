resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    port {
      name = "http"
      protocol = "TCP"
      port = 80
      target_port = 80
    }
    selector = { "app.kubernetes.io/name" : "nginx" }
    type = "LoadBalancer"
  }
}


resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app.kubernetes.io/name" : "nginx" }
    }
    template {
      metadata {
        labels = { "app.kubernetes.io/name" : "nginx" }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx"
        }
      }
    }
  }
}
