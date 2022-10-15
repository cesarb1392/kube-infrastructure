resource "kubernetes_ingress_v1" "portfolio" {
  metadata {
    name      = "portfolio"
    namespace = var.namespace
    annotations = {
      #      "konghq.com/plugins"    = "cloudflare-ips, bot-detect, rate-limit"
      "konghq.com/strip-path" = "false"
      "konghq.com/methods"    = "GET, POST"
      "konghq.com/protocols"  = "https"
    }
  }
  spec {
    ingress_class_name = "kong"
    rule {
      host = "cesarb.dev"
      http {
        path {
          backend {
            service {
              name = "portfolio"
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

resource "kubernetes_service" "portfolio_lb_service" {
  metadata {
    name      = "portfolio"
    namespace = var.namespace
  }
  spec {
    port {
      port = 80
      name = "http"
    }
    selector = { "app" : "portfolio" }
  }

}


resource "kubernetes_deployment_v1" "portfolio_lb_deployment" {
  metadata {
    name      = "portfolio"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app" : "portfolio" }
    }
    template {
      metadata {
        labels = { "app" : "portfolio" }
      }
      spec {
        container {
          name  = "portfolio"
          image = "monkeybanana13/portfolio"
          port {
            container_port = 80
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
