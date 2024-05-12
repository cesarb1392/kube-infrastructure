resource "null_resource" "graphite" {
  count = var.available.graphite ? 1 : 0

  provisioner "local-exec" {
    command     = "helm repo add kiwigrid https://kiwigrid.github.io"
    interpreter = ["sh", "-c"]
  }
}

resource "helm_release" "graphite" {
  count = var.available.graphite ? 1 : 0

  namespace = var.namespace
  name      = "graphite"
  chart     = "kiwigrid/graphite"

  # values     = [yamlencode(local.graphite)]
  depends_on = [null_resource.graphite]
}

locals {
  graphite = ({
    service = {
      annotation = {
        #          "metallb.universe.tf/allow-shared-ip" = "graphite-svc"
      }
      port = 80
      type = "LoadBalancer"
    }
    persistence = {
      enabled = false
    }
    resources = {
      limits = {
        cpu    = "500m"
        memory = "500Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
  })
}
