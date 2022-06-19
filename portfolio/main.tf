
resource "kubernetes_manifest" "ingress_route" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "portfolio-ingress"
      namespace = var.namespace
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          match = "Host(`cesarb.dev`)"
          kind  = "Rule"
          middlewares = [
            {
              name : kubernetes_manifest.cloudflare_ipwhitelist_middleware.manifest.metadata.name
              namespace : var.namespace
            },
            {
              name : kubernetes_manifest.rate_limit.manifest.metadata.name
              namespace : var.namespace

            },
            {
              name : kubernetes_manifest.simultaneous_connections.manifest.metadata.name
              namespace : var.namespace

            },
          ]
          services = [
            {
              name = "portfolio-ingress-lb-service"
              port = 80
            }
          ]
        }
      ]
    }
  }

}

resource "kubernetes_service" "portfolio_lb_service" {
  metadata {
    name      = "portfolio-ingress-lb-service"
    namespace = var.namespace
  }
  spec {
    port {
      port = 80
      name = "http"
    }
    selector = { "app" : "portfolio-ingress-lb" }
  }


}


resource "kubernetes_deployment_v1" "portfolio_lb_deployment" {
  metadata {
    name      = "portfolio-ingress-deployment"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app" : "portfolio-ingress-lb" }
    }
    template {
      metadata {
        labels = { "app" : "portfolio-ingress-lb" }
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
