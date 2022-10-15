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

resource "kubectl_manifest" "address_pool" {
  yaml_body = <<YAML
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: "default"
  namespace: "${var.namespace}"
spec:
 addresses: [${local.default_address_pool}]
YAML

  depends_on = [helm_release.metallb]
}

resource "kubectl_manifest" "advertisement" {
  yaml_body = <<YAML
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: "default"
  namespace: "${var.namespace}"
spec:
 ipAddressPools: ["default"]
YAML

  depends_on = [helm_release.metallb]
}

