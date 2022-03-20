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
      name      = "nginx-ingress"
      namespace = var.namespace
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          match = "Host(`nginx.cesarb.dev`)"
          kind  = "Rule"
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
  depends_on = [
    kubernetes_namespace.this
  ]
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
    selector = { "app.kubernetes.io/name" : "nginx-ingress-lb" }
  }
  depends_on = [kubernetes_namespace.this]

}


resource "kubernetes_deployment" "nginx_lb_deployment" {
  metadata {
    name      = "nginx-ingress-deployment"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app.kubernetes.io/name" : "nginx-ingress-lb" }
    }
    template {
      metadata {
        labels = { "app.kubernetes.io/name" : "nginx-ingress-lb" }
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
  depends_on = [kubernetes_namespace.this]
}
