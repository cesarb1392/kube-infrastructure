data "template_file" "wireguard" {
  template = yamlencode({
    # wg-access-server config
    config = {
      wireguard = {
        externalHost = var.host_ip
        privateKey   = var.private_key
      }
      loglevel = "debug"
      storage  = "sqlite3:///data/db.sqlite3"
      dns = {
        upstream = ["1.1.1.1"]
      }

    }
    web = {
      config = {
        adminUsername = var.user
        adminPassword = var.password
      }
      service = {
        type           = "LoadBalancer"
        loadBalancerIP = var.host_ip
        annotations = {
          "metallb.universe.tf/allow-shared-ip" = "wireguard-wg-access"
        }
      }
    }
    wireguard = {
      config = {
        privateKey = var.private_key
      }
      service = {
        type           = "LoadBalancer"
        loadBalancerIP = var.host_ip
        annotations = {
          "metallb.universe.tf/allow-shared-ip" = "wireguard-wg-access"
        }
      }
    }
    persistence = {
      enabled       = true
      existingClaim = var.persistent_volume_claim_name
    }

    nodeSelector = {
      "kubernetes.io/hostname" = "fastbanana2"
    }

    resources = {
      limits = {
        cpu    = "0.75"
        memory = "512Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
  })
}



resource "null_resource" "add_chart_locally" {
  provisioner "local-exec" {
    command     = "helm repo add wg-access-server https://cesarb1392.github.io/helm_charts/"
    interpreter = ["sh", "-c"]
  }
}

resource "helm_release" "this" {
  name      = "wg-access-server"
  chart     = "wg-access-server/wg-access-server"
  namespace = var.namespace
  version   = "1.0.0"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true

  values = [data.template_file.wireguard.rendered]

  depends_on = [null_resource.add_chart_locally]
}
