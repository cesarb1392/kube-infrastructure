resource "kubernetes_namespace" "this" {
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
    kubernetes_namespace.this,
  ]
}

data "template_file" "ingress_values" {
  template = file("${path.module}/config/traefik_helm_values.yaml")
  vars = {
    EMAIL  = var.K3S_CF_EMAIL
    DOMAIN = var.K3S_CF_DOMAIN
  }
}


