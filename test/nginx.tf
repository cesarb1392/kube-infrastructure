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
          path = "/"
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

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    port {
      name = "http"
      port = 80
    }
    selector = { "app.kubernetes.io/name" : "nginx" }
  }
}


resource "kubernetes_deployment" "nginx" {
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
