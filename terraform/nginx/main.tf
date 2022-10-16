resource "kubernetes_ingress_v1" "nginx" {
  metadata {
    name      = "nginx-ingress"
    namespace = var.namespace
  }
  spec {
    rule {
      host = "nginx.cesarb.dev"
      http {
        path {
          backend {
            service {
              name = "nginx"
              port {
                number = 80
              }
            }
          }
          path      = "/"
          path_type = "Prefix"
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
      target_port = 80
      port        = 80
    }
    selector = { "app" = "nginx" }
  }
}


resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app" = "nginx" }
    }
    template {
      metadata {
        labels = { "app" = "nginx" }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
