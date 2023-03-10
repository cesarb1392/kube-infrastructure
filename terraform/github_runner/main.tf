resource "kubernetes_secret" "this" {
  for_each = var.repositories

  metadata {
    name      = each.key
    namespace = var.namespace
  }
  data = {
    ACCESS_TOKEN   = var.ACCESS_TOKEN
    REPO_URL       = each.value.url
    RUNNER_WORKDIR = "/tmp/${each.key}"
    RUNNER_NAME    = each.key
  }
}

resource "kubernetes_deployment_v1" "this" {
  for_each = var.repositories

  metadata {
    name      = each.key
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app" : each.key }
    }
    template {
      metadata {
        labels = { "app" : each.key }
      }
      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/hostname"
                  operator = "In"
                  values   = ["slowbanana"]
                }
              }
            }
          }
        }
        container {
          name              = each.key
          image             = "myoung34/github-runner@sha256:755c68ec1cb8ca60c4f6816a8718d89829ce3fb5bc13c8c7778791ea48218df6"
          image_pull_policy = "IfNotPresent"
          env {
            name  = "EPHEMERAL"
            value = "true"
          }
          env {
            name = "ACCESS_TOKEN"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.this[each.key].metadata.0.name
                key      = "ACCESS_TOKEN"
                optional = false
              }
            }
          }
          env {
            name = "REPO_URL"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.this[each.key].metadata.0.name
                key      = "REPO_URL"
                optional = false
              }
            }
          }
          env {
            name = "RUNNER_WORKDIR"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.this[each.key].metadata.0.name
                key      = "RUNNER_WORKDIR"
                optional = false
              }
            }
          }
          env {
            name = "RUNNER_NAME"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.this[each.key].metadata.0.name
                key      = "RUNNER_NAME"
                optional = false
              }
            }
          }
          volume_mount {
            mount_path = "/var/run/docker.sock"
            name       = "dockersock"
          }
        }
        volume {
          name = "dockersock"
          host_path {
            path = "/var/run/docker.sock"
          }
        }
      }
    }
  }
}
