locals {
  metallb = {
    #    https://github.com/metallb/metallb/blob/main/charts/metallb/values.yaml
    speaker = {
      logLevel = var.log_level
    }
  }
  default_address_pool = var.address_pool
}

resource "helm_release" "metallb" {
  name  = "metallb"
  chart = "https://github.com/metallb/metallb/releases/download/metallb-chart-0.13.7/metallb-0.13.7.tgz?raw=true"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = var.namespace

  values = [yamlencode(local.metallb)]
}


/* data "kubectl_file_documents" "docs" {
  content = templatefile("${path.module}/crds.yaml", {
    default_address_pool = local.default_address_pool
    namespace            = var.namespace
  })
}

resource "kubectl_manifest" "this" {
  for_each  = data.kubectl_file_documents.docs.manifests
  yaml_body = each.value
} */

## Check out this!!
# resource "kubectl_manifest" "address_pool" {
#   yaml_body = <<-EOF
# apiVersion: metallb.io/v1beta1
# kind: IPAddressPool
# metadata:
#   name: "default"
#   namespace: "${var.namespace}"
# spec:
#  addresses: [${local.default_address_pool}]
# EOF

#   depends_on = [helm_release.metallb]
# }

# resource "kubectl_manifest" "advertisement" {
#   yaml_body = <<-EOF
# apiVersion: metallb.io/v1beta1
# kind: L2Advertisement
# metadata:
#   name: "default"
#   namespace: "${var.namespace}"
# spec:
#  ipAddressPools: ["default"]
# EOF

#   depends_on = [helm_release.metallb]
# } 
