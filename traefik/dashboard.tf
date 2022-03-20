/// change keys!!!!
resource "kubectl_manifest" "cf_api_keys" {
  count      = var.dashboard_ingress
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-credentials
  namespace: traefik
type: Opaque
stringData:
  email: contact@cesarb.dev
  apiKey: 1a3d8e7a88b62b865edfb636e74d860cc72de
YAML
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

resource "kubectl_manifest" "config" {
  count = var.dashboard_ingress

  yaml_body  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: traefik-config
  namespace: traefik
data:
  traefik-config.yaml: |
    http:
      middlewares:
        headers-default:
          headers:
            sslRedirect: true
            browserXssFilter: true
            contentTypeNosniff: true
            forceSTSHeader: true
            stsIncludeSubdomains: true
            stsPreload: true
            stsSeconds: 15552000
            customFrameOptionsValue: SAMEORIGIN
YAML
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

resource "kubectl_manifest" "secret_dashboard" {
  count = var.dashboard_ingress

  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: traefik-dashboard-auth
  namespace: traefik
data:
  users: |
    YmFuYW5hOiRhcHIxJDd6ZmZwZGEvJFJjclQ4bDEudzlONVVSWU8vRmk1TC8KCg==
YAML
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

resource "kubectl_manifest" "middleware_basicauth" {
  count = var.dashboard_ingress

  yaml_body  = <<YAML
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: traefik-dashboard-basicauth
  namespace: traefik
spec:
  basicAuth:
    secret: traefik-dashboard-auth
YAML
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

resource "kubectl_manifest" "ingress_route" {
  count = var.dashboard_ingress

  yaml_body  = <<YAML
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard
  namespace: traefik
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`traefik.cesarb.dev`)
      kind: Rule
      middlewares:
        - name: traefik-dashboard-basicauth
          namespace: traefik
      services:
        - name: api@internal
          kind: TraefikService
YAML
  depends_on = [
    kubernetes_namespace.traefik
  ]
}




