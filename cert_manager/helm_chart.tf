resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.namespace
    labels = {
      namespace = var.namespace
    }
    annotations = {
      name = "cert-manager"
    }
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace  = var.namespace
  #  version    ="1.0.4"

  set {
    name  = "installCRDs"
    value = "true"
  }
  depends_on = [kubernetes_namespace.cert_manager]
}

resource "kubectl_manifest" "cert_issuer" {
  yaml_body  = file("./cert_manager/issuer.yaml")
  depends_on = [kubernetes_namespace.cert_manager]
}
