resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.namespace
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = { "app" = var.namespace }
    }
    template {
      metadata {
        labels = { "app" = var.namespace }
      }
      spec {
        container {
          name              = "nginx"
          image             = "nginx"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = kubernetes_service.this.spec.0.port.0.port
          }

          liveness_probe {
            http_get {
              path = "/"
              port = kubernetes_service.this.spec.0.port.0.port
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
          volume_mount {
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path   = "default.conf"
            name       = kubernetes_config_map.nginx.metadata.0.name
            read_only  = true
          }

        }
        volume {
          name = kubernetes_config_map.nginx.metadata.0.name
          config_map {
            name = kubernetes_config_map.nginx.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "nginx" {
  metadata {
    name      = "${var.namespace}-nginx-host"
    namespace = var.namespace
  }
  data = {
    "default.conf" = templatefile("${path.module}/config.conf", {})
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = "${var.namespace}-svc"
    namespace = var.namespace
  }
  spec {
    port {
      port = var.ingress_port
    }
    selector = { "app" = var.namespace }
  }
}
