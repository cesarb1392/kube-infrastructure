resource "helm_release" "metallb" {
  name       = "metallb"
  chart      = "metallb"
  repository = "https://metallb.github.io/metallb"
  version    = "v0.13.5" # https://github.com/metallb/metallb/issues/1473

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = var.namespace

  values = [yamlencode(local.metalb_config)]
}

resource "kubernetes_manifest" "address_pool" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata   = {
      name      = "default"
      namespace = var.namespace
    }
    spec = {
      addresses = ["192.168.178.230-192.168.178.235"]
    }
  }
}

resource "kubernetes_manifest" "advertisement" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "L2Advertisement"
    metadata   = {
      name      = "default"
      namespace = var.namespace
    }
    spec = {
      ipAddressPools = ["default"]
    }
  }
}
