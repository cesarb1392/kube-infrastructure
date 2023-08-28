resource "null_resource" "smokeping" {
  count = var.available.smokeping ? 1 : 0

  provisioner "local-exec" {
    command     = "helm repo add nicholaswilde https://nicholaswilde.github.io/helm-charts/"
    interpreter = ["sh", "-c"]
  }
}

resource "helm_release" "smokeping" {
  count = var.available.smokeping ? 1 : 0

  namespace = var.namespace
  name      = "smokeping"
  chart     = "nicholaswilde/smokeping"

  values = [yamlencode(local.smokeping)]

  depends_on = [null_resource.smokeping]
}

locals {
  smokeping = {
    # https://github.com/nicholaswilde/helm-charts/blob/main/charts/smokeping/values.yaml
    service = {
      port = {
        port = 80
      }
    }
    env = {
      TZ = var.TZ
    }
  }
}

resource "kubernetes_service" "smokeping_lan" {
  count = var.available.smokeping ? 1 : 0

  metadata {
    name      = "smokeping-lan"
    namespace = var.namespace
  }
  spec {
    port {
      port = 80
    }
    type = "LoadBalancer"
    selector = {
      "app.kubernetes.io/instance" = "smokeping"
      "app.kubernetes.io/name"     = "smokeping"
    }
  }
}