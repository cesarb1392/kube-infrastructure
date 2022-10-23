# todo: can't make this work
#resource "helm_release" "pihole" {
#  name       = "pihole"
#  chart      = "mojo2600/pihole"
#  repository = "https://mojo2600.github.io/pihole-kubernetes/"
#
#  namespace  = var.namespace
#
#  timeout         = 120
#  cleanup_on_fail = true
#  force_update    = true
#
#  values = [
#    data.template_file.pihole_values.rendered
#  ]
#}

resource "null_resource" "add_chart_locally" {
  provisioner "local-exec" {
    command     = "helm repo add mojo2600 https://mojo2600.github.io/pihole-kubernetes/"
    interpreter = ["sh", "-c"]
  }
}

resource "helm_release" "this" {
  name      = "pihole"
  chart     = "mojo2600/pihole"
  namespace = var.namespace

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true

  values = [data.template_file.pihole_values.rendered]

  depends_on = [null_resource.add_chart_locally]
}



data "template_file" "pihole_values" {
#  https://github.com/MoJo2600/pihole-kubernetes/blob/master/charts/pihole/values.yaml
  template = yamlencode({
    dnsmasq = {
      customDnsEntries = ["address=/nas/192.168.178.10"]
    }
    customCnameEntries = ["cname=foo.nas,nas"]

    persistentVolumeClaim = { enabled = false }

#    ingress = {
#      enabled          = true,
#      ingressClassName = "nginx"
#      path             = "/"
#      hosts            = ["pihole.192.168.178.231.nip.io"]
#    }

    serviceWeb = {
      loadBalancerIP = "192.168.178.231"
      type           = "LoadBalancer"
      annotations = {
        "metallb.universe.tf/allow-shared-ip" = "pihole-svc"
      }
    }

    serviceDns = {
      loadBalancerIP = "192.168.178.231"
      annotations = {
        "metallb.universe.tf/allow-shared-ip" = "pihole-svc"
      }
      type = "LoadBalancer"
    }

    podDnsConfig = {
      enabled     = true
      policy      = "None"
      nameservers = ["127.0.0.1", "1.1.1.1"]
    }
    adminPassword = "bananas"
  })
}
