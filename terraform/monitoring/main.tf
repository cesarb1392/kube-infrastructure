#resource "kubernetes_service" "smokeping" {
#  metadata {
#    name      = "smokeping"
#    namespace = var.namespace
#  }
#  spec {
#    port {
#      port = 80
#    }
#    type     = "LoadBalancer"
#    selector = { "app" = "smokeping" }
#  }
#}
#
#resource "kubernetes_deployment_v1" "smokeping" {
#  metadata {
#    name      = "smokeping"
#    namespace = var.namespace
#  }
#  spec {
#    replicas = "1"
#    selector {
#      match_labels = { "app" = "smokeping" }
#    }
#    template {
#      metadata {
#        labels = { "app" = "smokeping" }
#      }
#      spec {
#        container {
#          name  = "smokeping"
#          image = "linuxserver/smokeping"
#          port {
#            container_port = 80
#          }
#
##          command = ["-f","/dev/null"]
#
#          env {
#            name  = "TZ"
#            value = var.TZ
#          }
#
#          liveness_probe {
#            http_get {
#              path = "/"
#              port = 80
#            }
#            initial_delay_seconds = 3
#            period_seconds        = 3
#          }
#          resources {
#            limits = {
#              cpu    = "250m"
#              memory = "128Mi"
#            }
#            requests = {
#              cpu    = "100m"
#              memory = "64Mi"
#            }
#          }
#        }
#      }
#    }
#  }
#}
