
resource "helm_release" "harbor" {
  namespace  = var.namespace
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"

  values = [
    data.template_file.helm_values.rendered
  ]

}
data "template_file" "helm_values" {
  template = file("${path.module}/harbor_helm_values.yaml")

}
