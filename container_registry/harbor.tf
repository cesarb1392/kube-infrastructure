resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
}

resource "helm_release" "harbor" {
  namespace  = var.namespace
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"

  values = [
    data.template_file.helm_values.rendered
  ]
  depends_on = [
    kubernetes_namespace.this,
  ]
}
data "template_file" "helm_values" {
  template = file("${path.module}/harbor_helm_values.yaml")

}
