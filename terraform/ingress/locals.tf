locals {
  kong_config = {
#    https://github.com/Kong/charts/blob/main/charts/kong/values.yaml
    "image": {
      "repository": "kong",
      "tag": "3.0"
    },
    "env": {
      "prefix": "/kong_prefix/",
      "database": "off"
    },
    "ingressController": {
      "enabled": true
    }
  }

  traefik_config = {
    #    https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml
    additionalArguments = [
      "--log.level=DEBUG",
      "--accesslog=true",
      "--accesslog.format=json",
      "--accesslog.filepath=/data/access.log",
      "--api.dashboard=true",
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

}
