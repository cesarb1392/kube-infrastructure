resource "helm_release" "metallb" {
  name       = "metallb"
  chart      = "metallb"
  repository = "https://metallb.github.io/metallb"
  version    = "v0.12.1"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = var.namespace

  # https://github.com/metallb/metallb/blob/main/charts/metallb/values.yaml
  values = [yamlencode(local.metalb_config)]
}
