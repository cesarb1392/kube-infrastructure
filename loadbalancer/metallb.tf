resource "kubernetes_namespace" "metallb" {
  metadata {
    name = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
}

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = var.namespace

  values = [
    data.template_file.metallb_values.rendered
  ]
  depends_on = [kubernetes_namespace.metallb, data.template_file.metallb_values]
}

data "template_file" "metallb_values" {
  template = file("${path.module}/metallb_helm_values.yaml")
  vars = {
    ADDRESS_RANGE = var.address_range
  }
}
