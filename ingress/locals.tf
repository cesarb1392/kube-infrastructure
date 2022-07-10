locals {
  traefik_config = {
    #    https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml
    additionalArguments = [
      "--log.level=DEBUG",
      "--metrics.prometheus",
      "--accesslog=true",
      "--accesslog.format=json",
      "--accesslog.filepath=/data/access.log",
      "--api.dashboard=true",

      #  "--providers.file.filename=/config/traefik-config.yaml",
      #  "--ping",
      #  "--ping.entrypoint=web",

      "--entrypoints.websecure.address=:8443",
      "--entrypoints.websecure.http.tls=true",
      "--entrypoints.websecure.http.tls.certresolver=cloudflare",
      "--entrypoints.websecure.http.tls.domains[0].main=${var.CF_DOMAIN}",
      "--entrypoints.websecure.http.tls.domains[0].sans=*.${var.CF_DOMAIN}",
      "--certificatesresolvers.cloudflare.acme.email=${var.CF_EMAIL}",
      "--certificatesresolvers.cloudflare.acme.dnschallenge.provider=cloudflare",
      "--certificatesresolvers.cloudflare.acme.dnschallenge.resolvers=1.1.1.1",
      "--certificatesresolvers.cloudflare.acme.storage=/certs/acme.json",
      # Set up an insecure listener that redirects all traffic to TLS
      "--entrypoints.web.address=:8000",
      "--entrypoints.web.http.redirections.entrypoint.to=websecure",
      "--entrypoints.web.http.redirections.entrypoint.scheme=https",
      "--entrypoints.web.http.redirections.entrypoint.permanent=true",
    ]
    ports = {
      web = {
        redirectTo : "websecure"
      }
    }
    ingressRoute = {
      dashboard = {
        enabled : false
      }
    }
    env = [
      {
        name : "CF_API_EMAIL"
        valueFrom = {
          secretKeyRef = {
            key  = "email"
            name = "cloudflare-api-credentials"
          }
        }
      },
      {
        name : "CF_API_KEY"
        valueFrom = {
          secretKeyRef = {
            key  = "apiKey"
            name = "cloudflare-api-credentials"
          }
        }
      }
    ]
    persistence = {
      enabled       = true
      path          = "/certs"
      size          = "128Mi"
      existingClaim = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.metadata[0].name
    }
    #    volumes = [
    #      {
    #        mountPath = "/config"
    #        name      = "traefik-config"
    #        type      = "configMap"
    #      }
    #    ]
    logs = {
      general = {
        level = "INFO"
      }
      access = {
        enabled = true
      }
    }
    persistence = {
      enabled       = true
      existingClaim = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.metadata[0].name
      size          = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.spec.0.resources.0.requests.storage
    }
  }
}
