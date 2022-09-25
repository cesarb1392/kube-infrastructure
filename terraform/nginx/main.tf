resource "kubernetes_ingress_v1" "nginx" {
#  wait_for_load_balancer = true
  metadata {
    name      = "nginx-ingress"
    namespace = var.namespace
    annotations = {
#      konghq.com/plugins = "rate-limiting"
    }
  }
  spec {
    ingress_class_name = "kong"
    rule {
      host = "test.nginx.svc.cluster.local"
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
      port = 80
      name = "http"
    }
    selector = { "app" : "nginx" }
  }
}


resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app" : "nginx" }
    }
    template {
      metadata {
        labels = { "app" : "nginx" }
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
