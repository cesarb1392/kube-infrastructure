/// change keys!!!!
resource "kubectl_manifest" "cf_api_keys" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-credentials
  namespace: ingress
type: Opaque
stringData:
  email:
  apiKey:
YAML
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

resource "kubectl_manifest" "config" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: traefik-config
  namespace: ingress
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
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: traefik-dashboard-auth
  namespace: ingress
data:
  users: |
    YmFuYW5hOiRhcHIxJDd6ZmZwZGEvJFJjclQ4bDEudzlONVVSWU8vRmk1TC8KCg==
YAML
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

resource "kubectl_manifest" "config_basicauth" {
  yaml_body = <<YAML
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: traefik-dashboard-basicauth
  namespace: ingress
spec:
  basicAuth:
    secret: traefik-dashboard-auth
YAML
  depends_on = [
    kubernetes_namespace.traefik
  ]
}

resource "kubectl_manifest" "ingress_route" {
  yaml_body = <<YAML
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard
  namespace: ingress
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`traefik.cesarb.dev`)
      kind: Rule
      middlewares:
        - name: traefik-dashboard-basicauth
          namespace: ingress
      services:
        - name: api@internal
          kind: TraefikService
YAML
  depends_on = [
    kubernetes_namespace.traefik
  ]
}




