locals {
  cert_manager = {
    # #https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml
    crds = {
      enabled = true
      keep    = true
    }
    # enableCertificateOwnerRef = true
  }
}

# Cert Manager
##https://opensource.com/article/20/3/ssl-letsencrypt-k3s
# https://cert-manager.io/docs/configuration/selfsigned/
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace  = var.namespace
  version    = "v1.17.1"

  values = [yamlencode(local.cert_manager)]
}



# The "banana-issuer" ClusterIssuer is used to issue the Root CA Certificate. 
# The "banana-ca-issuer" ClusterIssuer is used to issue but also sign certificates using the newly created Root CA Certificate, 
# which is what you will use for future certificates cluster-wide.
resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = <<-EOF
  apiVersion: cert-manager.io/v1
  kind: ClusterIssuer
  metadata:
    name: banana-issuer
  spec:
    selfSigned: {}
  
  EOF

  depends_on = [helm_release.cert_manager]
}

resource "kubectl_manifest" "root_ca_cert" {
  yaml_body = <<-EOF
  apiVersion: cert-manager.io/v1
  kind: Certificate
  metadata:
    name: banana-ca
    namespace: ${var.namespace}
  spec:
    isCA: true
    commonName: banana-ca
    secretName: banana-root-secret
    privateKey:
      algorithm: ECDSA
      size: 256
    issuerRef:
      name: banana-issuer
      kind: ClusterIssuer
      group: cert-manager.io
  
  EOF

  depends_on = [helm_release.cert_manager]
}

resource "kubectl_manifest" "sign_and_issue_certificates" {
  yaml_body = <<-EOF
  apiVersion: cert-manager.io/v1
  kind: ClusterIssuer
  metadata:
    name: banana-ca-issuer
  spec:
    ca:
      secretName: banana-root-secret
  EOF

  depends_on = [helm_release.cert_manager]
}

resource "kubectl_manifest" "cert" {
  yaml_body = <<-EOF
  apiVersion: cert-manager.io/v1
  kind: Certificate
  metadata:
    name: ${var.namespace}.${var.namespace}.svc.cluster.local
    namespace: ${var.namespace}
  spec:
    secretName: ${var.namespace}.${var.namespace}.svc.cluster.local
    duration: 2160h # 90 days
    renewBefore: 360h # 15 days
    dnsNames:
      - ${var.namespace}.${var.namespace}.svc.cluster.local
    issuerRef:
      name: banana-ca-issuer
      kind: ClusterIssuer
  EOF

  depends_on = [helm_release.cert_manager]
}