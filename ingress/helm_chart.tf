resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
}


resource "helm_release" "traefik" {
  namespace  = var.namespace
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"

  set {
    name  = "deployment.replicas"
    value = 1
  }

  set {
    name  = "chart.metadata.name"
    value = "traefik"
  }

  values = [
    data.template_file.ingress_values.rendered
  ]
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

data "template_file" "ingress_values" {
  template = file("ingress/values_cloudflare.yaml")
}


