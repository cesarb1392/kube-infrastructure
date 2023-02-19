locals {
  loki_values = {
    # https://github.com/grafana/loki/blob/main/production/helm/loki/values.yaml
    fullnameOverride = "loki"

    gateway = { enabled = false }

    loki = {
      # There is no authentication component here, but if you leave this setting on, Loki still tries to read the `X-scope-orgid` header
      authEnabled = false

      podAnnotations = {
        "prometheus.io/scrape" = "true"
      }
    }
    backend = {
      replicas = 2
      podAnnotations = {
        "prometheus.io/scrape" = "true"
      }
      persistence = {
        size = "512Mi"
      }
    }
    read = {
      replicas = 2
      podAnnotations = {
        "prometheus.io/scrape" = "true"
      }
      persistence = {
        size = "512Mi"
      }
    }
    serviceAccount = {
      create = true
    }
    write = {
      replicas = 2
      podAnnotations = {
        "prometheus.io/scrape" = "true"
      }
      persistence = {
        size = "512Mi"
      }
    }
    #    serviceMonitor = { enabled = true }
  }
}

resource "helm_release" "loki" {
  count = var.available.loki ? 1 : 0

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki" # Chose this one to separate read and write concerns, see more in https://grafana.com/docs/loki/latest/fundamentals/architecture/deployment-modes/#simple-scalable-deployment-mode
  name       = "grafana"
  #  version    = "1.4.3"

  namespace = var.namespace

  values = [
    yamlencode(local.loki_values)
  ]
}
