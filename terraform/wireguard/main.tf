locals {
  wireguard = {
    # wg-access-server config
    config = {
      wireguard = {
        externalHost = var.lan_ip
        privateKey   = var.private_key
      }
      loglevel = var.log_level
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
        loadBalancerIP = var.lan_ip
        annotations = {
          "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-wg-access"
        }
      }
    }
    wireguard = {
      config = {
        privateKey = var.private_key
      }
      service = {
        type           = "LoadBalancer"
        loadBalancerIP = var.lan_ip
        annotations = {
          "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-wg-access"
        }
      }
    }
    persistence = {
      existingClaim = var.persistent_volume_claim_name
    }

    nodeSelector = {
      "kubernetes.io/hostname" = "fastbanana"
    }

    resources = {
      limits = {
        cpu    = "100m"
        memory = "128Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
  }
}

resource "helm_release" "this" {
  name      = var.namespace
  chart     = "https://github.com/cesarb1392/helm_charts/releases/download/wireguard-1.4.0/wireguard-1.4.0.tgz?raw=true"
  namespace = var.namespace

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true

  values = [yamlencode(local.wireguard)]
}


# https://www.reddit.com/r/WireGuard/comments/10vq2y9/comment/j7n9hsd/?utm_source=share&utm_medium=web2x&context=3
resource "cloudflare_record" "vpn_record" {
  zone_id = var.CF_ZONE_ID
  name    = "vpn"
  type    = "A"
  value   = var.public_ip
  proxied = false
}


# todo add labels to nodes
