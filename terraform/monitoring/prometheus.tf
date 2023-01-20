locals {
  #  https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/values.yaml
  prometheus_values = {
    "alertmanager"     = { "enabled" = false }
    "kubeStateMetrics" = { "enabled" = true }
    "nodeExporter"     = { "enabled" = true }
    "pushgateway"      = { "enabled" = false }

    "rbac" = { "create" = true }

    "serviceAccounts" = {
      "alertmanager" = { "create" = false }
      "nodeExporter" = { "create" = true }
      "pushgateway"  = { "create" = false }
      "server"       = { "create" = true }
    }
    "serverFiles" = {
      "prometheus.yml" = {
        "scrape_configs" = [] # Kill the default scrape configs, since the client is doing them
      }
    }
    "server" = {
      "extraFlags" = [
        # These do not need the leading `--`
        "web.enable-remote-write-receiver"
      ]
      "persistentVolume" = {
        #        "size" = "1Gi"
      }
      "resources" = {
        "requests" = {
          "cpu"    = "250m"
          "memory" = "500Mi"
        }
        "limits" = {
          "cpu"    = "1000m"
          "memory" = "1500Mi"
        }
      }
      "readinessProbeFailureThreshold" = 4
      "readinessProbePeriodSeconds"    = 30
      "readinessProbeTimeout"          = 15
      "livenessProbeFailureThreshold"  = 8
      "livenessProbePeriodSeconds"     = 30
      "livenessProbeTimeout"           = 15
      "startupProbe"                   = { "enabled" = true }
      "strategy" = {
        "type" = "Recreate" # Because we have a single volume to attach and are not currently using HA
      }
    }
  }


}

resource "helm_release" "prometheus_server" {
  count = var.available.prometheus ? 1 : 0

  chart      = "prometheus"
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = var.namespace

  version = "15.10.1"

  values = [
    yamlencode(local.prometheus_values)
  ]
}