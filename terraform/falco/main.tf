locals {
  falco = {
    #     # https://github.com/falcosecurity/charts/blob/master/charts/falco/values.yaml
    scc = { create : false }
    # customRules        = {} # Add rule overrides if needed 
    # fakeEventGenerator = { enabled = true }

    # driver = {
    #   kind = "auto"
    #   # kind = "ebpf"  # Preferred for containerized environments vs kernel module
    # }
    falcosidekick = {
      enabled    = true
      listenPort = 2801
      webui = {
        enabled      = true,
        replicaCount = 1
      }
    }
    # ebpf = {
    #   hostNetwork = true  # Required for eBPF in some environments
    # }
    # tty = true

    # resources = {
    #   requests = { cpu = "1", memory = "1280Mi" }
    #   limits = { memory = "1280Mi" }
    # }
    # (combined from similar events): Error creating: pods "falco-hjdc7" is forbidden: [maximum memory usage per Container is 1Gi, but limit is 1280Mi, maximum memory usage per Pod is 1Gi, but li │
    # │ it is 1536Mi, maximum cpu usage per Pod is 1, but limit is 1250m[]
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
      target_port = 2801
      protocol    = "TCP"
    }
    selector = {
      "app.kubernetes.io/name" = var.namespace
    }
    type = "LoadBalancer"
  }
}

