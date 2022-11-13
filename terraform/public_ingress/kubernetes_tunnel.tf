resource "kubernetes_secret_v1" "this" {
  metadata {
    name      = "tunnel-credentials-${var.namespace}"
    namespace = var.namespace
  }
  data = {
    "credentials.json" = jsonencode({
      "AccountTag"   = var.CF_ACCOUNT_ID,
      "TunnelSecret" = random_id.this.b64_std,
      "TunnelID"     = cloudflare_argo_tunnel.this.id
    })
  }
  type = "Opaque"
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = "cloudflared-${var.namespace}"
    namespace = var.namespace
    annotations = {
      # restart pods when configmap or secret changes
      config_change = sha1(jsonencode(merge(
        kubernetes_config_map_v1.this.data,
        kubernetes_secret_v1.this.data
      )))
    }
  }
  spec {
    replicas = "1"
    selector {
      match_labels = { app = "cloudflared-${var.namespace}" }
    }
    template {
      metadata {
        labels = { app = "cloudflared-${var.namespace}" }
      }
      spec {
        container {
          name              = "cloudflared-${var.namespace}"
          image             = "cloudflare/cloudflared:2022.10.0-arm64"
          args              = ["tunnel", "--config", "/etc/cloudflared/config/config.yaml", "run"]
          image_pull_policy = "IfNotPresent"

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
            secret_name = kubernetes_secret_v1.this.metadata.0.name
          }
        }
        volume {
          name = "config"
          config_map {
            name = "cloudflared-${var.namespace}"
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

resource "kubernetes_config_map_v1" "this" {
  metadata {
    name      = "cloudflared-${var.namespace}"
    namespace = var.namespace
  }
  data = {
    "config.yaml" = yamlencode({
      tunnel           = cloudflare_argo_tunnel.this.name
      credentials-file = "/etc/cloudflared/creds/credentials.json"
      metrics          = "0.0.0.0:2000"
      no-autoupdate    = true
      ingress = [
        {
          hostname = "${var.hostname}.${var.CF_ZONE_NAME}"
          service  = "http://${var.target_service}:${var.ingress_port}"
        },
        { service = "http_status:404" }
      ]
    })
  }
}
