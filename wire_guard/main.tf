resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
    labels = {
      namespace = var.namespace
    }
  }
}

resource "helm_release" "wireguard" {
  name      = var.namespace
  namespace = var.namespace
  #  chart      = "wg-access-server"
  #  repository = "https://place1.github.io/wg-access-server"
  chart      = "wireguard"
  repository = "https://k8s-at-home.com/charts/"
  values = [
    data.template_file.wireguard_values.rendered
  ]
  depends_on = [kubernetes_namespace.this, data.template_file.wireguard_values]

}

data "template_file" "wireguard_values" {
  template = file("${path.module}/values.yaml")
  #  vars = {
  #    PVC = kubernetes_persistent_volume_claim_v1.wireguard_persistent_volume_claim.metadata[0].name
  #  }
}
