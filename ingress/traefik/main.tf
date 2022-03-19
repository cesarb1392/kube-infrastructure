resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
}

resource "helm_release" "traefik" {
  namespace        = var.namespace
  name             = "traefik"
  repository       = "https://helm.traefik.io/traefik"
  chart            = "traefik"

  set {
    name = "deployment.replicas"
    value = 2
  }

  set {
    name = "chart.metadata.name"
    value = "traefik"
  }

    values = [
      file("./traefik/Chart.yaml")
    ]
  depends_on = [
    kubernetes_namespace.traefik
  ]
}
