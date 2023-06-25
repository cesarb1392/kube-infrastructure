#resource "kubernetes_service_v1" "transmission" {
#  metadata {
#    name      = join("", [var.namespace, "-transmission"])
#    namespace = var.namespace
#    labels = {
#      namespace = var.namespace
#    }
#  }
#  spec {
#    port {
#      port        = local.ports.transmission.external
#      target_port = local.ports.transmission.internal
#      name        = "http"
#    }
#    selector = kubernetes_deployment_v1.transmission.spec.0.selector.0.match_labels
#  }
#}
#
#resource "kubernetes_service_v1" "jackett" {
#  metadata {
#    name      = join("", [var.namespace, "-jackett"])
#    namespace = var.namespace
#  }
#  spec {
#    port {
#      port        = local.ports.jackett.external
#      target_port = local.ports.jackett.internal
#      name        = "http"
#    }
#    selector = kubernetes_deployment_v1.jackett.spec.0.selector.0.match_labels
#  }
#}