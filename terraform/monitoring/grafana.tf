locals {
  #  https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml
  grafana_values = {
    adminUser     = "z"
    adminPassword = "z"
    #    "admin" = {
    #      "existingSecret" = kubernetes_secret_v1.admin_password.metadata[0].name
    #      "userKey"     = "x"
    #      "passwordKey" = "x"
    #    }

    "datasources" = {
      "datasources.yaml" = {
        "apiVersion" = 1
        "datasources" = [{
          "name"      = "Prometheus"
          "type"      = "prometheus"
          "url"       = "http://prometheus-server.monitoring.svc.cluster.local"
          "access"    = "proxy"
          "isDefault" = true
          }, {
          "name"      = "Loki"
          "type"      = "loki"
          "url"       = "http://loki-read.monitoring.svc.cluster.local:3100"
          "access"    = "proxy"
          "isDefault" = false
        }]
      }
    }

    "deploymentStrategy" = {
      "type" = "Recreate"
    }

    "grafana.ini" = {
      "server" = {
        "domain" = "local.hostname"
      }
      #      "auth" = {
      #        "disable_signout_menu" = "true"
      #      }
      "users" = {
        "auto_assign_org_role" = "Editor"
      }
      "force_migration" = "true"
    }

    #    "persistence" = {
    #      "enabled" = true
    #      #      "existingClaim" = kubernetes_persistent_volume_claim_v1.grafana.metadata[0].name
    #    }
    service = {
      type           = "LoadBalancer"
      loadBalancerIP = var.lan_ip
      annotations = {
        "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-grafana"
      }
    }

    "podAnnotations" = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port" : "3000"
    }

    "podLabels" = {
      # The default Grafana dashboard expects this name, so we override the job name as it's scraped by Prometheus
      # This works because the kubernetes-pods job in the default Prometheus config uses a relabel action
      "job" : "grafana"
    }

    "rbac" = {
      "create"     = true
      "namespaced" = true
      "pspEnabled" = false
    }
  }
}
resource "helm_release" "grafana" {
  count = var.available.grafana ? 1 : 0

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  name       = "grafana"
  version    = "6.29.11"

  namespace = var.namespace

  values = [
    yamlencode(local.grafana_values)
  ]
}
