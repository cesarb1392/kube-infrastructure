resource "helm_release" "metallb" {
  name       = "metallb"
  chart      = "metallb"
  repository = "https://metallb.github.io/metallb"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = var.namespace

  values = [yamlencode(local.metalb_config)]
}

