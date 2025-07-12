resource "helm_release" "prometheus_server" {
  count = var.available.prometheus_stack ? 1 : 0

  chart      = "kube-prometheus-stack"
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = var.namespace

  values = [file("${path.module}/prometheus_stack.yaml")]
}


# https://grafana.com/grafana/dashboards/15282-k8s-rke-cluster-monitoring/
resource "kubernetes_service_v1" "grafana_lan" {
  count = var.available.prometheus_stack ? 1 : 0

  metadata {
    name      = "grafana-lan"
    namespace = var.namespace
    annotations = {
      "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-svc"
    }
  }
  spec {
    load_balancer_ip = var.lan_ip
    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
      name        = "lan-http"
    }
    selector = {
      "app.kubernetes.io/instance" = "prometheus"
      "app.kubernetes.io/name"     = "grafana"
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_persistent_volume_claim" "this" {
  count = var.available.prometheus_stack ? 1 : 0

  wait_until_bound = false # otherwise pending forever since the pod isnt created yet

  metadata {
    name      = "prometheus-prometheus-kube-prometheus-prometheus-db-prometheus-prometheus-kube-prometheus-prometheus-0" # "${var.namespace}-transmission-pvc"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name" = "${var.namespace}-pv"
    }
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-path"
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}
