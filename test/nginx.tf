resource "kubernetes_ingress_v1" "nginx" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class" = "traefik"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/nginx"
          backend {
            service {
              name = "nginx"
              port {
                name = "http"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
    selector = { "app.kubernetes.io/name" : "nginx" }
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
