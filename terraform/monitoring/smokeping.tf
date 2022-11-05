resource "null_resource" "smokeping" {
  provisioner "local-exec" {
    command     = "helm repo add nicholaswilde https://nicholaswilde.github.io/helm-charts/"
    interpreter = ["sh", "-c"]
  }
}

resource "helm_release" "smokeping" {
  namespace = var.namespace
  name      = "smokeping"
  chart     = "nicholaswilde/smokeping"

  values = [data.template_file.smokeping.rendered]

  depends_on = [null_resource.smokeping]
}

data "template_file" "smokeping" {
  template = yamlencode({
    # https://github.com/nicholaswilde/helm-charts/blob/main/charts/smokeping/values.yaml
    service = {
      port = {
        port = 80
      }
    }
    env = {
      TZ = var.TZ
    }
  })
}

resource "kubernetes_service" "smokeping_lan" {
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