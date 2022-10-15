locals {
  kong_config = {
#            https://github.com/Kong/charts/blob/main/charts/kong/values.yaml
        "image" = {
          "repository" = "kong",
          "tag"        = "3.0"
        },
        "env" = {
          "prefix"   = "/kong_prefix/",
          "database" = "off"
        },
        "ingressController" = {
          "enabled" = true
          "env"     = {
            "anonymous_reports" = true
          },
          "customEnv" = {
            "TZ" = "Europe/Amsterdam"
          },
        }
        autoscaling = {
          enabled     = true
          minReplicas = 1
          maxReplicas = 5
        }
  }

  traefik_config = {
    #    https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml
    additionalArguments = [
      "--log.level=DEBUG",
      "--metrics.prometheus",
      "--accesslog=true",
      "--accesslog.format=json",
      "--accesslog.filepath=/data/access.log",
      "--api.dashboard=true",
      "--entrypoints.web.address=:80",
    ]

    ingressRoute = {
      dashboard = {
        enabled : false
      }
    }
    logs = {
      general = {
        level = "INFO"
      }
      access = {
        enabled = true
      }
    }
  }

  nginx_config = {
#     https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
    fullnameOverride = "ingress-nginx"
    controller = {

      kind           = "DaemonSet"
      hostNetwork    = true
      hostPort       = { enabled = true }
      service        = { enabled = false }
      publishService = { enabled = false }
      metrics        = { enabled = true }
      serviceMonitor = { enabled = true }
      config         = { use-forwarded-headers = "true" }
    }
  }
}
