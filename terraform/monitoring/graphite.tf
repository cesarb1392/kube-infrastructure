#resource "null_resource" "graphite" {
#  provisioner "local-exec" {
#    command     = "helm repo add kiwigrid https://kiwigrid.github.io"
#    interpreter = ["sh", "-c"]
#  }
#}
#
#resource "helm_release" "graphite" {
#  namespace = var.namespace
#  name      = "graphite"
#  chart     = "kiwigrid/graphite"
#
#  values = [data.template_file.graphite.rendered]
# depends_on = [null_resource.graphite]
#}
#
#data "template_file" "graphite" {
#  template = yamlencode({
#    service = {
#      annotation = {
#        #          "metallb.universe.tf/allow-shared-ip" = "graphite-svc"
#      }
#      port = 80
#      type = "LoadBalancer"
#    }
#    persistence = {
#      enabled = false
#    }
#    resources = {
#      limits = {
#        cpu    = "500m"
#        memory = "500Mi"
#      }
#      requests = {
#        cpu    = "100m"
#        memory = "128Mi"
#      }
#    }
#  })
#}
