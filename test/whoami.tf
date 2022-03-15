resource "kubernetes_ingress_v1" "whoami" {
  metadata {
    name      = "whoami"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class" = "traefik"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/whoami"
          backend {
            service {
              name = "whoami"
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

resource "kubernetes_service" "whoami" {
  metadata {
    name      = "whoami"
    namespace = var.namespace
  }
  spec {
    port {
      name = "http"
      port = 80
    }
    selector = { "app.kubernetes.io/name" : "whoami" }
  }
}


resource "kubernetes_deployment" "whoami" {
  metadata {
    name      = "whoami"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app.kubernetes.io/name" : "whoami" }
    }
    template {
      metadata {
        labels = { "app.kubernetes.io/name" : "whoami" }
      }
      spec {
        container {
          name  = "whoami"
          image = "containous/whoami"
        }
      }
    }
  }
}
