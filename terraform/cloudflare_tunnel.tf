resource "random_id" "argo_secret_traefik" {
  byte_length = 32
}

resource "cloudflare_argo_tunnel" "access_tunnel_traefik" {
  account_id = var.CF_ACCOUNT_ID
  name       = "tunnel-traefik"
  secret     = random_id.argo_secret_traefik.b64_std
}

resource "cloudflare_record" "access_tunnel_traefik" {
  zone_id = var.CF_ZONE_ID
  name    = "*"
  value   = cloudflare_argo_tunnel.access_tunnel_traefik.cname
  type    = "CNAME"
  proxied = true
}

resource "kubernetes_secret_v1" "tunnel_credentials_traefik" {
  metadata {
    name      = "tunnel-credentials-traefik"
    namespace = "kube-system"
  }
  data = {
    "credentials.json" = jsonencode({
      "AccountTag"   = var.CF_ACCOUNT_ID,
      "TunnelSecret" = random_id.argo_secret_traefik.b64_std,
      "TunnelID"     = cloudflare_argo_tunnel.access_tunnel_traefik.id
    })
  }
  type = "Opaque"
}

resource "kubernetes_deployment_v1" "cloudflared_traefik" {
  metadata {
    name      = "cloudflared-traefik"
    namespace = "kube-system"
  }
  spec {
    replicas = "1"
    selector {
      match_labels = { app = "cloudflared-traefik" }
    }
    template {
      metadata {
        labels = { app = "cloudflared-traefik" }
      }
      spec {
        container {
          name  = "cloudflared-traefik"
          image = "cloudflare/cloudflared:2022.10.0-arm64"
          args  = ["tunnel", "--config", "/etc/cloudflared/config/config.yaml", "run"]
          liveness_probe {
            http_get {
              path = "/ready"
              port = 2000
            }
            failure_threshold     = 1
            initial_delay_seconds = 20
            period_seconds        = 10
          }
          volume_mount {
            mount_path = "/etc/cloudflared/config"
            name       = "config"
            read_only  = true
          }
          volume_mount {
            mount_path = "/etc/cloudflared/creds"
            name       = "creds"
            read_only  = true
          }
        }
        volume {
          name = "creds"
          secret {
            secret_name = kubernetes_secret_v1.tunnel_credentials_traefik.metadata.0.name
          }
        }
        volume {
          name = "config"
          config_map {
            name = "cloudflared-traefik"
            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map_v1" "cloudflare_tunnel_config_traefik" {
  metadata {
    name      = "cloudflared-traefik"
    namespace = "kube-system"
  }
  data = {
    "config.yaml" = yamlencode({
      tunnel           = cloudflare_argo_tunnel.access_tunnel_traefik.name
      credentials-file = "/etc/cloudflared/creds/credentials.json"
      metrics          = "0.0.0.0:2000"
      no-autoupdate    = true
      ingress = [
        {
          hostname = "nginx.cesarb.dev"
          service  = "http://traefik:80"
        },
        { service = "http_status:404" }
      ]
    })
  }
}
