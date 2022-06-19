resource "kubernetes_manifest" "ingress_route" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "nginx-ingress"
      namespace = var.namespace
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          match = "Host(`nginx.cesarb.dev`)"
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
              name = "nginx-ingress-lb-service"
              port = 80
            }
          ]
        }
      ]
    }
  }

}

resource "kubernetes_service" "nginx_lb_service" {
  metadata {
    name      = "nginx-ingress-lb-service"
    namespace = var.namespace
  }
  spec {
    port {
      port = 80
      name = "http"
    }
    selector = { "app" : "nginx-ingress-lb" }
  }
}


resource "kubernetes_deployment_v1" "nginx_lb_deployment" {
  metadata {
    name      = "nginx-ingress-deployment"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app" : "nginx-ingress-lb" }
    }
    template {
      metadata {
        labels = { "app" : "nginx-ingress-lb" }
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
