# https://github.com/Place1/wg-access-server/blob/master/deploy/helm/wg-access-server/values.yaml

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
    #    resources = {
    #      limits = {
    #        cpu    = "250m"
    #        memory = "250Mi"
    #      }
    #      requests = {
    #        cpu    = "100m"
    #        memory = "128Mi"
    #      }
    #    }
  })
}


resource "helm_release" "wireguard" {
  name       = var.namespace
  namespace  = var.namespace
  chart      = "wg-access-server"
  repository = "https://place1.github.io/wg-access-server"
  values     = [data.template_file.wireguard.rendered]
  version    = "0.4.6"
}

