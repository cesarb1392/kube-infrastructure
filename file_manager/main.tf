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
      name      = "${var.namespace}-ingress"
      namespace = var.namespace
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          #          match = "Host(`filemanager.cesarb.dev`)"
          match = "Host(`filemanager.192.168.2.20.nip.io`)"
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
              name = "${var.namespace}-service"
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

resource "kubernetes_service" "filemanager_lb_service" {
  metadata {
    name      = "${var.namespace}-service"
    namespace = var.namespace
  }
  spec {
    port {
      port = 80
      name = "http"
    }
    selector = { "app" : var.namespace }
  }
  depends_on = [kubernetes_namespace.this]

}


resource "kubernetes_deployment_v1" "filemanager_lb_deployment" {
  metadata {
    name      = "${var.namespace}-deployment"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app" : var.namespace }
    }
    template {
      metadata {
        labels = { "app" : var.namespace }
      }
      spec {
        container {
          name  = "filemanager"
          image = "monkeybanana13/tinyfilemanager:main"
          port {
            container_port = 80
          }
          volume_mount {
            mount_path = "/var/www/html/data"
            name       = "data"
            sub_path   = "downloads/transmission"
          }
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.metadata[0].name
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.this]
}
