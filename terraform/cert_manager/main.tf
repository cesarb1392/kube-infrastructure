resource "helm_release" "cert_manager" {
  namespace  = var.namespace
  name       = "jetstack"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.9.1"

  values = [yamlencode(local.cert_manager_config)]
}


resource "kubectl_manifest" "letsencrypt_prod" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: "letsencrypt-prod"
spec:
 acme:
  email: "contact@cesarb.dev"
  server: "https://acme-v02.api.letsencrypt.org/directory"
  privateKeySecretRef:
    name: "letsencrypt-prod"
  solvers:
    - dns01:
        cloudflare:
          email : "contact@cesarb.dev"
          apiTokenSecretRef:
            name : ${kubernetes_secret.api_token.metadata.0.name}
            key  : "api-token"
        selector:
          dnsZones:
            - 'cesarb.dev'
            - '*.cesarb.dev'
YAML

  depends_on = [helm_release.cert_manager]
}

resource "kubernetes_secret" "api_token" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = var.namespace
  }
  data = {
    api-token = var.CF_API_TOKEN
  }
}