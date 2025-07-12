resource "kubernetes_service" "this" {
  metadata {
    name      = var.target_service
    namespace = var.namespace
  }
  spec {
    port {
      port = var.ingress_port
    }
    selector = { "app" = var.app_name }
  }
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = { "app" = var.app_name }
    }
    template {
      metadata {
        labels = { "app" = var.app_name }
      }
      spec {
        container {
          name              = var.app_name
          image             = var.app_image
          image_pull_policy = "IfNotPresent"
          resources {
            limits = {
              memory = "50Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "50Mi"
            }
          }
          port {
            container_port = var.ingress_port
          }
          liveness_probe {
            http_get {
              path = "/"
              port = var.ingress_port
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
