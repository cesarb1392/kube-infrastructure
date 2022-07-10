resource "kubernetes_secret" "env_vars" {
  metadata {
    name      = "env-vars"
    namespace = var.namespace
  }
  data = {
    ACCESS_TOKEN   = var.ACCESS_TOKEN
    REPO_URL       = var.REPO_URL
    RUNNER_WORKDIR = var.RUNNER_WORKDIR
    RUNNER_NAME    = var.RUNNER_NAME
  }
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = "${var.namespace}-deployment"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { "app" : var.namespace }
    }
    template {
      metadata {
        labels = { "app" : var.namespace }
      }
      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/hostname"
                  operator = "In"
                  values   = ["fastbanana2"]
                }
              }
            }
          }
        }
        container {
          name  = var.namespace
          image = "myoung34/github-runner:latest"

          env {
            name = "ACCESS_TOKEN"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "ACCESS_TOKEN"
                optional = false
              }
            }
          }
          env {
            name = "REPO_URL"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "REPO_URL"
                optional = false
              }
            }
          }
          env {
            name = "RUNNER_WORKDIR"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "RUNNER_WORKDIR"
                optional = false
              }
            }
          }
          env {
            name = "RUNNER_NAME"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.env_vars.metadata.0.name
                key      = "RUNNER_NAME"
                optional = false
              }
            }
          }


          volume_mount {
            mount_path = "/var/run/docker.sock"
            name       = "dockersock"
          }
          volume_mount {
            mount_path = "/tmp/runner"
            name       = "data"
          }
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.persistent_volume_claim.metadata[0].name
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
