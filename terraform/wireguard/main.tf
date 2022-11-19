data "template_file" "wireguard" {
  template = yamlencode({
    # wg-access-server config
    config = {
      wireguard = {
        externalHost = var.host_ip
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
        loadBalancerIP = var.host_ip
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
        loadBalancerIP = var.host_ip
        annotations = {
          "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-wg-access"
        }
      }
    }
    persistence = {
      existingClaim = "${var.namespace}-pvc" # kubernetes_persistent_volume_claim.this.metadata.0.name
    }

    nodeSelector = {
      "kubernetes.io/hostname" = "fastbanana1"
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

resource "helm_release" "this" {
  name      = var.namespace
  chart     = "https://github.com/cesarb1392/helm_charts/releases/download/wireguard-1.4.0/wireguard-1.4.0.tgz?raw=true"
  namespace = var.namespace

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true

  values = [data.template_file.wireguard.rendered]
}


resource "kubernetes_persistent_volume" "this" {
  metadata {
    name = "${var.namespace}-pv"
  }
  spec {
    persistent_volume_reclaim_policy = "Delete"
    storage_class_name               = "local-path"
    access_modes                     = ["ReadWriteOnce"]
    capacity = {
      storage = "100Mi"
    }
    persistent_volume_source {
      host_path {
        path = "/tmp/${var.namespace}"
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["fastbanana1"]
          }
        }
      }
    }
  }
}


resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name      = "${var.namespace}-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-path"
    resources {
      requests = {
        storage = "100Mi"
      }
    }
  }
  depends_on = [kubernetes_persistent_volume.this]
}
