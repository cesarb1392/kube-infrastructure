resource "kubernetes_secret" "env_vars" {
  metadata {
    name      = "env-vars"
    namespace = var.namespace
  }
  data = {
    CLIENT_ID       = var.CLIENT_ID
    CLIENT_SECRET   = var.CLIENT_SECRET
    EMAIL_FROM      = var.EMAIL_FROM
    EMAIL_TO        = var.EMAIL_TO
    REFRESH_TOKEN   = var.REFRESH_TOKEN
    SCRAPE_URL_BUY  = var.SCRAPE_URL_BUY
    SCRAPE_URL_RENT = var.SCRAPE_URL_RENT
  }
}

resource "kubernetes_deployment" "house_searching_notifier" {
  metadata {
    name      = var.namespace
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { app = var.namespace }
    }
    replicas = "1"
    template {
      metadata {
        labels = { app = var.namespace }
      }
      spec {
        container {
          name              = "house-searching-notifier"
          image             = "monkeybanana13/house_searching_notifier:1.3.0"
          image_pull_policy = "IfNotPresent"

          env {
            name = "SCRAPE_URL_BUY"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "SCRAPE_URL_BUY"
                optional = false
              }
            }
          }
          env {
            name = "SCRAPE_URL_RENT"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "SCRAPE_URL_RENT"
                optional = false
              }
            }
          }
          env {
            name = "EMAIL_FROM"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "EMAIL_FROM"
                optional = false
              }
            }
          }
          env {
            name = "EMAIL_TO"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "EMAIL_TO"
                optional = false
              }
            }
          }
          env {
            name = "REFRESH_TOKEN"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "REFRESH_TOKEN"
                optional = false
              }
            }
          }
          env {
            name = "CLIENT_SECRET"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "CLIENT_SECRET"
                optional = false
              }
            }
          }
          env {
            name = "CLIENT_ID"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "CLIENT_ID"
                optional = false
              }
            }
          }

          resources {
            limits = {
              cpu    = "1"
              memory = "128Mi"
            }
            requests = {
              cpu    = "0.5"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}
