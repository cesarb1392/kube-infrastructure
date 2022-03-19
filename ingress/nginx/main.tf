resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "traefik"
    labels = {
      namespace = "traefik"
    }
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  namespace  = "traefik"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.watchNamespace"
    value = "nginx"
  }

  set {
    name  = "controller.ingressClassResource.name"
    value = "nginx"
  }

  set {
    name  = "controller.ingressClassResource.controllerValue"
    value = "k8s.io/${"nginx"}"
  }

  set {
    name  = "controller.ingressClassResource.enabled"
    value = true
  }

  set {
    name  = "controller.ingressClassByName"
    value = true
  }

  set {
    name  = "controller.nodeSelector.\\beta\\.kubernetes\\.io/os"
    value = "linux"
  }
  depends_on = [kubernetes_namespace.nginx]
}
