resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
}

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
          #          match = "Host(`cesarb.dev`)"
          match = "Host(`cesarb.192.168.2.20.nip.io`)"
          kind  = "Rule"
          middlewares = [
            {
              name : "cloudflare-ip-whitelist"
              namespace : var.namespace
            },
            {
              name : "rate-limit"
              namespace : var.namespace
            }
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
  depends_on = [
    kubernetes_namespace.this
  ]
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
  depends_on = [kubernetes_namespace.this]

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
  depends_on = [kubernetes_namespace.this]
}
