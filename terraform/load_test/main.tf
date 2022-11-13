resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = "loadtest"
    namespace = var.namespace
  }
  spec {
    replicas = "1"
    selector {
      match_labels = { "app" = "loadtest" }
    }
    template {
      metadata {
        labels = { "app" = "loadtest" }
      }
      spec {
        container {
          name  = "loadtest"
          image = "24hoursmedia/k6-xarch"
          args  = ["run", "--discard-response-bodies", "--vus=10", "--stage=1m:1000", "--stage=3s:0", "--quiet", "--linger", "/tmp/loadtest-config/index.js"]

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "0.5"
            }
            limits = {
              memory = "1Gi"
              cpu    = 1
            }
          }
          volume_mount {
            mount_path = "/tmp/loadtest-config"
            name       = kubernetes_config_map.this.metadata.0.name
          }
        }
        volume {
          name = kubernetes_config_map.this.metadata.0.name
          config_map {
            name = kubernetes_config_map.this.metadata.0.name
          }
        }
      }
    }
  }
}


resource "kubernetes_config_map" "this" {
  metadata {
    name      = "loadtest"
    namespace = var.namespace
  }

  data = {
    "index.js" = templatefile("${path.module}/index.js", { target_url = var.target_url })
  }
}