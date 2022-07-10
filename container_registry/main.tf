
resource "helm_release" "harbor" {
  namespace  = var.namespace
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"

  values = [yamlencode(local.harbor_config)]

}
