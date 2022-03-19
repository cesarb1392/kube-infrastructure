resource "kubernetes_namespace" "cert_manager" {
  metadata {
    annotations = {
      name = "cert-manager"
    }
    name = "cert-manager"
  }
}

# Install helm release Cert Manager
resource "helm_release" "cert-manager" {
  name       = var.cert_manager_name
  chart      = var.cert_manager_name
  repository = var.cert_manager_repo
  version    = var.cert_manager_version
  namespace  = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

#https://github.com/rafrasenberg/kubernetes-terraform-traefik-cert-manager
