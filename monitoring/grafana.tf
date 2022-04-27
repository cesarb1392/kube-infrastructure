
data "template_file" "grafana_values" {
  template = file("${path.module}/grafana_helm_values.yaml")

  vars = {
    GRAFANA_SERVICE_ACCOUNT = "grafana"
    GRAFANA_ADMIN_USER      = var.K3S_GRAFANA_USER
    GRAFANA_ADMIN_PASSWORD  = var.K3S_GRAFANA_PASSWORD
    PROMETHEUS_SVC          = "monitoring-prometheus-server"
    NAMESPACE               = var.namespace
    PVC_NAME                = kubernetes_persistent_volume_claim_v1.grafana_persistent_volume_claim.metadata[0].name
  }
}

resource "helm_release" "grafana" {
  chart      = "grafana"
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = var.namespace

  values = [
    data.template_file.grafana_values.rendered
  ]
}
resource "kubernetes_manifest" "ingress_route" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "grafana"
      namespace = var.namespace
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          #          match = "Host(`grafana.cesarb.dev`)"
          match = "Host(`grafana.192.168.2.20.nip.io`)"
          kind  = "Rule"
          services = [
            {
              name = "grafana-service"
              port = 3000
            }
          ]
        }
      ]
    }
  }
  depends_on = [
    kubernetes_namespace.this
  ]
}


resource "kubernetes_service" "grafana_lb_service" {
  metadata {
    name      = "grafana-service"
    namespace = var.namespace
  }
  spec {
    port {
      port        = 3000
      target_port = 3000
      name        = "http"
    }
    selector = { "app.kubernetes.io/name" : "grafana", app : "grafana" }
  }
  depends_on = [kubernetes_namespace.this]
}
