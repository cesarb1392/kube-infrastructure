# https://min.io/docs/minio/kubernetes/upstream/index.html?ref=docs-redirect
# https://github.com/minio/minio/blob/master/helm/minio/values.yaml
resource "helm_release" "minio_storage" {
  namespace = var.namespace
  name      = "minio"
  chart     = "https://github.com/minio/minio/blob/master/helm-releases/minio-4.0.9.tgz?raw=true"

  values = [
    yamlencode({
      mode         = "standalone"
      replicas     = 1
      rootUser     = var.MINIO_ROOT_USER
      rootPassword = var.MINIO_ROOT_PASSWORD
      persistence = {
        size = "5Gi"
      }
      service = {
        type = "ClusterIP"
        port = var.ingress_port
      }
      consoleService = {
        type = "ClusterIP"
        port = 80 # web ui
      }

      resources = {
        requests = {
          memory = "500Mi"
          cpu    = 1
        }
        limits = {
          memory = "1Gi"
          cpu    = 2
        }
      }
      users = var.MINIO_USERS
    })
  ]
}