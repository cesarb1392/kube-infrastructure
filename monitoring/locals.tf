locals {
  prometheus_values = {
    "alertmanager"     = { "enabled" = false }
    "kubeStateMetrics" = { "enabled" = true }
    "nodeExporter"     = { "enabled" = false }
    "pushgateway"      = { "enabled" = false }

    "serviceAccounts" = {
      "alertmanager" = { "create" = false }
      "nodeExporter" = { "create" = false }
      "pushgateway"  = { "create" = false }
      "server"       = { "create" = true }
    }

    "server" = {
      "strategy" = {
        "type" = "Recreate" # Because we have a single volume to attach and are not currently using HA
      }
    }
  }
  grafana_values = {
    adminUser      = var.K3S_GRAFANA_USER
    adminPassword  = var.K3S_GRAFANA_PASSWORD
    serviceAccount = { name : "grafana" }
    persistence = {
      enabled : true
      existingClaim : kubernetes_persistent_volume_claim_v1.grafana_persistent_volume_claim.metadata[0].name
      size : "2Gi"
      finalizers : []
    }
    datasources = {
      "datasources.yaml"= {
        datasources = [{
          name= "Prometheus"
          type= "prometheus"
          url = "http://prometheus-server.${var.namespace}.svc.cluster.local"
        }]
      }
    }
  }
}
