locals {
  traefik_config = {
    #    https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml
    additionalArguments = [
      "--providers.file.filename=/data/traefik-config.yaml",
      #  "--ping",
      #  "--ping.entrypoint=web",
      "--entrypoints.websecure.http.tls.certresolver=cloudflare",
      "--entrypoints.websecure.http.tls.domains[0].main=${var.K3S_CF_DOMAIN}",
      "--entrypoints.websecure.http.tls.domains[0].sans=*.${var.K3S_CF_DOMAIN}",
      "--certificatesresolvers.cloudflare.acme.dnschallenge.provider=cloudflare",
      #  "--certificatesresolvers.dns-cloudflare.acme.dnschallenge=true
      "--certificatesresolvers.cloudflare.acme.email=${var.K3S_CF_EMAIL}",
      "--certificatesresolvers.cloudflare.acme.dnschallenge.resolvers=1.1.1.1",
      "--certificatesresolvers.cloudflare.acme.storage=/certs/acme.json",
      "--log.level=INFO",
      "--metrics.prometheus",
      #  "--providers.kubernetesIngress.ingressClass=traefik-cert-manager",
      "--accesslog=true",
      "--accesslog.format=json",
      "--accesslog.filepath=/data/access.log",
      #  "--tracing.jaeger=true",
      #  "--tracing.jaeger.samplingServerURL=http://jaeger-agent.default.svc:5778/sampling",
      #  "--tracing.jaeger.localAgentHostPort=jaeger-agent.default.svc:6831",
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
      enabled = true
      path    = "/certs"
      size    = "128Mi"
      #  existingClaim: "ingress-traefik-volume-claim"
    }
    volumes = [
      {
        mountPath = "/data"
        name      = "traefik-config"
        type      = "configMap"
      }
    ]
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
