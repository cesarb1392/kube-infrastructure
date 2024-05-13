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
  chart = "https://github.com/metallb/metallb/releases/download/metallb-chart-0.14.5/metallb-0.14.5.tgz?raw=true"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = var.namespace

  values = [yamlencode(local.metallb)]
}

# data "kubectl_file_documents" "docs" {
#   content = templatefile("${path.module}/crds.yaml", {
#     default_address_pool = local.default_address_pool
#     namespace            = var.namespace
#   })
# }

# resource "kubectl_manifest" "this" {
#   for_each  = data.kubectl_file_documents.docs.manifests
#   yaml_body = each.value
# }

# # # Check out this!!
# resource "kubectl_manifest" "address_pool" {
#   yaml_body = <<-EOF
#   apiVersion: metallb.io/v1beta1
#   kind: IPAddressPool
#   metadata:
#     name: "default"
#     namespace: "${var.namespace}"
#   spec:
#     addresses:
#     - "192.168.178.230-192.168.178.240"
#     autoAssign: true
#     avoidBuggyIPs: false
#   EOF

#   depends_on = [helm_release.metallb]
# }

# resource "kubectl_manifest" "advertisement" {
#   yaml_body = <<-EOF
#     apiVersion: metallb.io/v1beta1
#     kind: L2Advertisement
#     metadata:
#       name: "default"
#       namespace: "${var.namespace}"
#     spec:
#       ipAddressPools: ["${kubectl_manifest.address_pool.name}"]
# EOF

#   depends_on = [helm_release.metallb]
# } 
