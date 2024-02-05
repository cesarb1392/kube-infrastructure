locals {
  # https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
  prometheus_values = {
    defaultRules = {
      rules = { alertmanager = false }
    }
    alertmanager = {
      enabled = false,
      alertmanagerSpec = {
        nodeSelector = {
          "name" = "slowbanana"
        }
      }
  } }
  prometheusOperator = {
    nodeSelector   = { nodeSelector = { "name" = "slowbanana" } }
    prometheusSpec = { nodeSelector = { "name" = "slowbanana" } }
    admissionWebhooks = {
      # patch = {
      #   nodeSelector = { "name" = "slowbanana" }
      # }
      deployment = { nodeSelector = { "name" = "slowbanana" } }
    }
  }

  server = {
    #          persistentVolume = {
    #            size = "5Gi"
    #      resources = {
    #        requests = {
    #          cpu    = "250m"
    #          memory = "256Mi"
    #        }
    #      }
  }
  #    configmapReload = {
  #      prometheus = {
  #
  #      }
  #    }

  grafana = {
    enabled       = false
    adminPassword = "xxx" # grafana-cli admin reset-admin-password "xxx"
  }
  prometheus = {
    prometheusSpec = {
      retention    = "10d"
      replicas     = 1
      nodeSelector = { "name" = "slowbanana" }
      #        storageSpec = {}
    }
  }
}



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

/* 
resource "kubernetes_service_v1" "carlosedp_monitoring" {
  count = var.available.carlosedp_monitoring ? 1 : 0

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
      "app." = "grafana"
    }
    type = "LoadBalancer"
  }
} */
