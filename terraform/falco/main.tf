locals {
  falco = {
    # https://github.com/falcosecurity/charts/blob/master/charts/falco/values.yaml
    scc                = { create = false }
    customRules        = {} # Add rule overrides if needed 
    fakeEventGenerator = { enabled = false }
    driver = {
      enabled = true
      kind    = "kmod"
      ## sudo apt update && sudo apt upgrade -y && sudo apt install --no-install-recommends dkms && sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source && sudo chmod +x /usr/bin/rpi-source && rpi-source --skip-gcc && dkms --version
      # kind = "ebpf" # Preferred for containerized environments vs kernel module
    }
    containerd = {
      enabled = true
      socket  = "/run/k3s/containerd/containerd.sock"
    }

    falcosidekick = {
      # https://github.com/falcosecurity/charts/blob/master/charts/falcosidekick/values.yaml
      enabled    = true
      listenPort = 2801
      webui = {
        enabled      = true
        user         = "${var.user}:${var.pass}"
        loglevel     = "info"
        replicaCount = 1
        # allowcors = false
        image = {
          tag = "2.2.0"
        }
        service = {
          annotations = {
            "metallb.io/ip-allocated-from-pool"   = "default"
            "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-svc"
          }
        }
      }
    }
    tty = true
    collectors = {
      enabled    = true
      docker     = { enabled = false }
      crio       = { enabled = false }
      containerd = { enabled = true, socket = "/run/k3s/containerd/containerd.sock" }
      kubernetes = { enabled = true }

    }
    resources = {
      requests = {
        cpu    = "500m", # Request half a core
        memory = "512Mi" # Request 512 MiB
      }
      limits = {
        memory = "512Mi"
      }
    }
  }
}

resource "helm_release" "this" {
  name      = var.namespace
  namespace = var.namespace
  chart     = "https://github.com/falcosecurity/charts/releases/download/falco-4.21.3/falco-4.21.3.tgz?raw=true"
  wait      = true
  timeout   = 600
  values    = [yamlencode(local.falco)]
}

resource "kubernetes_service_v1" "falco_lan" {
  metadata {
    name      = "${var.namespace}-lan"
    namespace = var.namespace
    annotations = {
      "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-svc"
      "metallb.io/ip-allocated-from-pool"   = "default"
    }
  }
  spec {
    load_balancer_ip = var.lan_ip
    port {
      port        = 80
      target_port = 2802
      protocol    = "TCP"
    }
    selector = {
      "app.kubernetes.io/component" : "ui"
      "app.kubernetes.io/instance" : "falco"
      "app.kubernetes.io/name" : "falcosidekick"
    }
    type = "LoadBalancer"
  }
}

