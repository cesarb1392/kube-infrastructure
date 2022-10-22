locals {
  chart_config = {
    #    https://github.com/metallb/metallb/blob/main/charts/metallb/values.yaml
    speaker = {
      logLevel = var.log_level
    }
  }
  default_address_pool = "192.168.178.230-192.168.178.235"
}

resource "helm_release" "metallb" {
  name  = "metallb"
  chart = "https://github.com/metallb/metallb/releases/download/metallb-chart-0.13.7/metallb-0.13.7.tgz?raw=true"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = var.namespace

  values = [yamlencode(local.chart_config)]
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
