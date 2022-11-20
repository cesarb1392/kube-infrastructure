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
  #  version = "2.9.3"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true

  values = [data.template_file.pihole_values.rendered]

  depends_on = [null_resource.add_chart_locally]
}

data "template_file" "pihole_values" {
  #  https://github.com/MoJo2600/pihole-kubernetes/blob/master/charts/pihole/values.yaml
  template = yamlencode({
    replicaCount = 1
    # maximum number of Pods that can be created over the desired number of `ReplicaSet` during updating.
    maxSurge = 1
    # maximum number of Pods that can be unavailable during updating
    maxUnavailable = 1

    resources = {
      limits = {
        cpu    = "500m"
        memory = "500Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
    dnsmasq = {
      customDnsEntries = []
    }
    customCnameEntries = []

    persistentVolumeClaim = {
      enabled = false
      size    = "500Mi"
    }

    image = {
      repository = "pihole/pihole"
      tag        = "2022.10"
      pullPolicy = "IfNotPresent"
    }

    serviceWeb = {
      loadBalancerIP = var.host_ip
      type           = "LoadBalancer"
      annotations = {
        "metallb.universe.tf/allow-shared-ip" = "pihole-svc"
      }
    }

    serviceDns = {
      loadBalancerIP = var.host_ip
      annotations = {
        "metallb.universe.tf/allow-shared-ip" = "pihole-svc"
      }
      type = "LoadBalancer"
    }

    podDnsConfig = {
      enabled     = true
      policy      = "None"
      nameservers = ["127.0.0.1", "1.1.1.1", "1.0.0.1"]
    }
    adminPassword = var.password
  })
}
