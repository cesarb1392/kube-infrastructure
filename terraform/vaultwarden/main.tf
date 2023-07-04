locals {
  app_name = var.namespace
  env_vars = {
    #    https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
    SERVER_ADMIN_EMAIL  = var.SERVER_ADMIN_EMAIL
    ORG_CREATION_USERS  = var.SERVER_ADMIN_EMAIL
    DOMAIN              = "https://${local.app_name}.${var.DOMAIN}"
    SHOW_PASSWORD_HINT  = false
    INVITATIONS_ALLOWED = false
    SIGNUPS_ALLOWED     = false
    SHOW_PASSWORD_HINT  = false
    WEB_VAULT_ENABLED   = true
    WEBSOCKET_ENABLED   = true ## websocket notifications
    ADMIN_TOKEN         = var.VAULTWARDEN_ADMIN_TOKEN
    LOG_LEVEL           = var.log_level # "trace", "debug", "info", "warn", "error" and "off"
    EXTENDED_LOGGING    = true
  }
  env_vars_hash = sha1(jsonencode(kubernetes_secret.this.data))
}
#https://greg.jeanmart.me/2020/04/13/self-host-your-password-manager-with-bitward/
resource "kubernetes_deployment" "this" {
  metadata {
    name      = local.app_name
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = { "app" = local.app_name }
    }
    template {
      metadata {
        labels = { "app" = local.app_name }
      }
      spec {

        container {
          name              = "vaultwarden"
          image             = "vaultwarden/server"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = kubernetes_service.this.spec.0.port.0.port
          }

          env {
            name  = "ENV_VARS_HASH"
            value = local.env_vars_hash
          }

          liveness_probe {
            http_get {
              path = "/"
              port = kubernetes_service.this.spec.0.port.0.port
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
          volume_mount {
            mount_path = ".env"
            sub_path   = "env_vars"
            name       = kubernetes_secret.this.metadata.0.name
            read_only  = true
          }
          volume_mount {
            mount_path = "/data"
            name       = var.persistent_volume_claim_name
          }
        }
        volume {
          name = kubernetes_secret.this.metadata.0.name
          secret {
            secret_name = kubernetes_secret.this.metadata.0.name
          }
        }
        volume {
          name = var.persistent_volume_claim_name
          persistent_volume_claim {
            claim_name = var.persistent_volume_claim_name
          }
        }
      }
    }
  }
}

resource "kubernetes_secret" "this" {
  metadata {
    name      = "env-vars"
    namespace = var.namespace
  }
  data = {
    "env_vars" = join("\n", [
      for k, v in local.env_vars : "${k}=${v}"
    ])
  }
  type = "Opaque"
}

resource "kubernetes_service" "this" {
  metadata {
    name      = "${local.app_name}-svc"
    namespace = var.namespace
  }
  spec {
    port {
      port = var.ingress_port
    }
    selector = { "app" = local.app_name }
  }
}
