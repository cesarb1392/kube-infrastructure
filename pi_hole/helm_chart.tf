resource "helm_release" "pihole" {
  chart      = "pihole"
  name       = "mojo2600"
  repository = "https://mojo2600.github.io/pihole-kubernetes"

  namespace       = var.namespace
  timeout         = 120
  cleanup_on_fail = true
  force_update    = true

  values = [
    data.template_file.pihole_values.rendered
  ]
  depends_on = [data.template_file.pihole_values]
}

data "template_file" "pihole_values" {
  template = file("${path.module}/values.yaml")
  vars = {
    PVC      = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.metadata[0].name
    PASSWORD = var.K3S_PIHOLE_PASSWORD # changes to existingSecret
  }
}
#
#resource "kubernetes_secret_v1" "pihole_secret_keys" {
#  metadata {
#    name      = join("", [var.namespace, "-pi-hole-secret"])
#    namespace = var.namespace
#    labels = {
#      namespace = var.namespace
#    }
#  }
#  data = {
#    password = var.K3S_PIHOLE_PASSWORD
#  }
#}
