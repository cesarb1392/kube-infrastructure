#resource "kubernetes_ingress_v1" "nginx_lb" {
#
#  metadata {
#    name        = "nginx-ingress"
#    namespace   = var.namespace
#    annotations = {
#      "kubernetes.io/ingress.class" = "traefik"
##      "cert-manager.io/cluster-issuer" : "letsencrypt-issuer"
#      "traefik.frontend.rule" = "Host(`nginx.cesarb.dev`)"
#    }
#  }
#
#  spec {
##    default_backend {
##      service {
##        name = "nginx-ingress-service"
##        port {
##          number = 80
##        }
##      }
##    }
#
#    rule {
#      http {
#        path {
#          path = "/"
#          backend {
#            service {
#              name = "nginx-ingress-service"
#              port {
#                number = 80
#              }
#            }
#          }
#        }
#      }
#    }
##    tls {
##      secret_name = "nginx-cert"
##    }
#  }
#  depends_on = [kubernetes_namespace.this]
#}

resource "kubectl_manifest" "ingress_route" {
  yaml_body = <<YAML
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: nginx
  namespace: nginx
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`nginx.cesarb.dev`)
      kind: Rule
      middlewares:
        - name: basicauth
          namespace: nginx
      services:
        - name: nginx-ingress-service
          kind: Service
YAML
  depends_on = [
    kubernetes_namespace.this
  ]
}

resource "kubernetes_service" "nginx_lb_service" {
  metadata {
    name      = "nginx-ingress-service"
    namespace = var.namespace
  }
  spec {
    port {
      name = "http"
      port = 80
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

#resource "kubectl_manifest" "cert_issuer" {
#  yaml_body = file("./test/cert_nginx.yaml")
#}
