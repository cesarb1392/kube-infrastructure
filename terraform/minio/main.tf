# https://min.io/docs/minio/kubernetes/upstream/index.html?ref=docs-redirect
# https://github.com/minio/minio/blob/master/helm/minio/values.yaml
resource "helm_release" "minio_storage" {
  namespace = var.namespace
  name      = "minio"
  chart     = "https://github.com/minio/minio/blob/master/helm-releases/minio-5.0.9.tgz?raw=true"

  values = [data.template_file.this.rendered]
}


data "template_file" "this" {
  template = yamlencode(
    {
      mode         = "standalone"
      replicas     = 1
      rootUser     = var.MINIO_ROOT_USER
      rootPassword = var.MINIO_ROOT_PASSWORD
      persistence = {
        existingClaim = var.persistent_volume_claim_name
      }
      service = {
        type = "ClusterIP"
        port = var.ingress_port
      }
      consoleService = {
        type = "ClusterIP"
        port = 9091 # web ui
      }

      resources = {
        requests = {
          memory = "500Mi"
          cpu    = 1
        }
        limits = {
          memory = "1Gi"
          cpu    = 1
        }
      }
      users = var.MINIO_USERS
    }
  )
}

resource "kubernetes_service_v1" "minio_lan" {
  metadata {
    name      = "${var.namespace}-lan"
    namespace = var.namespace
    annotations = {
      "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-svc"
    }
  }
  spec {
    load_balancer_ip = var.lan_ip
    port {
      port        = 80
      target_port = 9001
      protocol    = "TCP"
      name        = "lan-http"
    }
    selector = {
      "app"     = var.namespace
      "release" = var.namespace
    }
    type = "LoadBalancer"
  }
}

