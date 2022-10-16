resource "random_id" "argo_secret" {
  byte_length = 32
}
resource "cloudflare_argo_tunnel" "access_tunnel" {
  account_id = var.CF_ACCOUNT_ID
  name       = "tunnel-nginx2"
  secret     = random_id.argo_secret.b64_std
}

resource "cloudflare_record" "access_tunnel" {
  zone_id = var.CF_ZONE_ID
  name    = "nginx2"
  value   = cloudflare_argo_tunnel.access_tunnel.cname
  type    = "CNAME"
  proxied = true
}

resource "kubernetes_secret_v1" "tunnel_credentials" {
  metadata {
    name      = "tunnel-credentials-nginx2"
    namespace = "kube-system"
  }
  data = {
    "credentials.json" = jsonencode({
      "AccountTag"   = var.CF_ACCOUNT_ID,
      "TunnelSecret" = random_id.argo_secret.b64_std,
      "TunnelID"     = cloudflare_argo_tunnel.access_tunnel.id
    })
  }
  type = "Opaque"
}

resource "kubectl_manifest" "cloudflared_nginx2" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cloudflared-nginx2
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: cloudflared-nginx2
  replicas: 1 # You could also consider elastic scaling for this deployment
  template:
    metadata:
      labels:
        app: cloudflared-nginx2
    spec:
      containers:
      - name: cloudflared-nginx2
        image: cloudflare/cloudflared:2022.10.0-arm64
        args:
        - tunnel
        # Points cloudflared to the config file, which configures what
        # cloudflared will actually do. This file is created by a ConfigMap
        # below.
        - --config
        - /etc/cloudflared/config/config.yaml
        - run
        livenessProbe:
          httpGet:
            # Cloudflared has a /ready endpoint which returns 200 if and only if
            # it has an active connection to the edge.
            path: /ready
            port: 2000
          failureThreshold: 1
          initialDelaySeconds: 10
          periodSeconds: 10
        volumeMounts:
        - name: config
          mountPath: /etc/cloudflared/config
          readOnly: true
        # Each tunnel has an associated "credentials file" which authorizes machines
        # to run the tunnel. cloudflared will read this file from its local filesystem,
        # and it'll be stored in a k8s secret.
        - name: creds
          mountPath: /etc/cloudflared/creds
          readOnly: true
      volumes:
      - name: creds
        secret:
          secretName: ${kubernetes_secret_v1.tunnel_credentials.metadata.0.name}
      - name: config
        configMap:
          name: cloudflared-nginx2
          items:
          - key: config.yaml
            path: config.yaml
YAML

  depends_on = [cloudflare_argo_tunnel.access_tunnel]
}

resource "kubectl_manifest" "cloudflare_tunnel_config_nginx2" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: cloudflared-nginx2
  namespace: kube-system
data:
  config.yaml: |
    tunnel: ${cloudflare_argo_tunnel.access_tunnel.name}
    credentials-file: /etc/cloudflared/creds/credentials.json
    metrics: 0.0.0.0:2000
    no-autoupdate: true
    ingress:
    - hostname: nginx2.cesarb.dev
      service: http://nginx2:80
    - service: http_status:404

YAML
}

resource "kubectl_manifest" "service_nginx2" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: nginx2
  namespace: kube-system
spec:
  selector:
    app: nginx2
  ports:
    - protocol: TCP
      port: 80
  YAML
}
resource "kubectl_manifest" "app_nginx2" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx2
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: nginx2
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx2
    spec:
      containers:
      - name: nginx2
        image: nginx
        ports:
        - containerPort: 80
  YAML

}

