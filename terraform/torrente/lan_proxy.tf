locals { domain = "nginx-proxy" }

resource "kubernetes_service_v1" "nginx" {
  metadata {
    name      = local.domain
    namespace = var.namespace
    annotations = {
      "metallb.universe.tf/allow-shared-ip" = "torrente-svc"
    }
  }
  spec {
    port {
      port        = 80
      target_port = 80
      name        = local.domain
    }
    selector         = { app = local.domain }
    type             = "LoadBalancer"
    load_balancer_ip = var.lan_ip
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = local.domain
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = { app = local.domain }
    }
    template {
      metadata {
        labels = { app = local.domain }
      }
      spec {
        container {
          image = "nginx"
          name  = local.domain
          port {
            container_port = kubernetes_service_v1.nginx.spec.0.port.0.target_port
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = kubernetes_service_v1.nginx.spec.0.port.0.target_port
            }
            initial_delay_seconds = 3
            period_seconds        = 30
            timeout_seconds       = 20
            failure_threshold     = 10
            success_threshold     = 1
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = kubernetes_service_v1.nginx.spec.0.port.0.target_port
            }
            initial_delay_seconds = 3
            period_seconds        = 10
          }

          volume_mount {
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path   = "default.conf"
            name       = kubernetes_config_map.nginx.metadata.0.name
            read_only  = true
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "nginx" {
  metadata {
    name      = local.domain
    namespace = var.namespace
  }
  data = {
    "default.conf" = <<EOF
      server {
          listen 80;
          server_name     nginx-proxy;

          error_log  /dev/stdout;
          access_log /dev/stdout;

          location /health {
            access_log off;
            add_header 'Content-Type' 'application/json';
            return 200 '{"status":"Healthy"}';
          }

          location / {
              client_max_body_size 2000m;
              proxy_buffering off;
              proxy_ssl_verify off;
              proxy_set_header Host $http_host;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_pass http://torrente-transmission.torrente.svc.cluster.local:9090;
        }
      }
EOF
  }
}


#resource "kubernetes_deployment" "nginx" {
#  metadata {
#    name      = local.domain
#    namespace = var.namespace
#  }
#  spec {
#    replicas = 1
#    selector {
#      match_labels = { app = local.domain }
#    }
#    template {
#      metadata {
#        labels = { app = local.domain }
#      }
#      spec {
#        container {
#          image = "nginx"
#          name  = local.domain
#          port {
#            container_port = kubernetes_service_v1.nginx.spec.0.port.0.target_port
#          }
#
#          liveness_probe {
#            http_get {
#              path = "/health"
#              port = kubernetes_service_v1.nginx.spec.0.port.0.target_port
#            }
#            initial_delay_seconds = 3
#            period_seconds        = 30
#            timeout_seconds       = 20
#            failure_threshold     = 10
#            success_threshold     = 1
#          }
#          readiness_probe {
#            http_get {
#              path = "/health"
#              port = kubernetes_service_v1.nginx.spec.0.port.0.target_port
#            }
#            initial_delay_seconds = 3
#            period_seconds        = 10
#          }
#
#          volume_mount {
#            mount_path = "/etc/nginx/conf.d/default.conf"
#            sub_path   = "default.conf"
#            name       = kubernetes_config_map.nginx.metadata.0.name
#            read_only  = true
#          }
#          volume_mount {
#            mount_path = "/etc/nginx/tls.crt"
#            sub_path   = "tls.crt"
#            name       = "tls-cert"
#            read_only  = true
#          }
#          volume_mount {
#            mount_path = "/etc/nginx/tls.key"
#            sub_path   = "tls.key"
#            name       = "cert-key"
#            read_only  = true
#          }
#        }
#
#        volume {
#          name = kubernetes_config_map.nginx.metadata.0.name
#          config_map {
#            name = kubernetes_config_map.nginx.metadata.0.name
#          }

#        }

#        volume {
#          name = "tls-cert"
#          secret {
#            secret_name = "nginx-proxy-certs"
#            items {
#              key  = "tls.crt"
#              path = "tls.crt"
#            }
#          }
#        }
#        volume {
#          name = "cert-key"
#          secret {
#            secret_name = "nginx-proxy-certs"
#            items {
#              key  = "tls.key"
#              path = "tls.key"
#            }
#          }
#        }
#      }
#    }
#  }
#}
#resource "kubernetes_config_map" "nginx" {
#  metadata {
#    name      = local.domain
#    namespace = var.namespace
#  }
#  data = {
#    "default.conf" = <<EOF
#      server {
#          listen 443;
#          server_name     nginx-proxy;
#          add_header      Strict-Transport-Security "max-age=31536000" always;
#          ssl_certificate /etc/nginx/tls.crt;
#          ssl_certificate_key /etc/nginx/tls.key;
#          ssl_stapling on;
#          ssl_stapling_verify on;
#
#          error_log  /dev/stdout;
#          access_log /dev/stdout;
#
#          location /health {
#            access_log off;
#            add_header 'Content-Type' 'application/json';
#            return 200 '{"status":"Healthy"}';
#          }
#
#          location / {
#              client_max_body_size 2000m;
#              proxy_buffering off;
#              proxy_ssl_verify off;
#              proxy_set_header Host $http_host;
#              proxy_set_header Upgrade $http_upgrade;
#              proxy_set_header Connection "Upgrade";
#              proxy_set_header X-Forwarded-Proto $scheme;
#              proxy_pass http://torrente-transmission.torrente.svc.cluster.local:9090;
#        }
#      }
#EOF
#  }
#}
#
#resource "kubernetes_secret" "certs" {
#  metadata {
#    name      = "nginx-proxy-certs"
#    namespace = var.namespace
#  }
#  data = {
#    "tls.crt" = tls_self_signed_cert.ca.cert_pem
#    "tls.key" = tls_private_key.ca.private_key_pem
#  }
#}
#
#resource "tls_private_key" "ca" {
#  algorithm = "RSA"
#}
#
#resource "tls_self_signed_cert" "ca" {
#  private_key_pem = tls_private_key.ca.private_key_pem
#
#  subject {
#    common_name  = local.domain
#    organization = "ACME"
#  }
#
#  allowed_uses = [
#    "key_encipherment",
#    "cert_signing",
#    "server_auth",
#    "client_auth",
#  ]
#
#  validity_period_hours = 24000
#  early_renewal_hours   = 720
#  is_ca_certificate     = true
#}
#
#resource "tls_private_key" "default" {
#  algorithm = "RSA"
#}
#
#resource "tls_cert_request" "default" {
#  private_key_pem = tls_private_key.default.private_key_pem
#
#  dns_names = [
#    local.domain,
#    "www.${local.domain}",
#  ]
#
#  subject {
#    common_name  = local.domain
#    organization = "ACME"
#  }
#}
#
#resource "tls_locally_signed_cert" "default" {
#  cert_request_pem   = tls_cert_request.default.cert_request_pem
#  ca_private_key_pem = tls_private_key.ca.private_key_pem
#  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem
#
#  validity_period_hours = 42000
#
#  allowed_uses = [
#    "key_encipherment",
#    "digital_signature",
#    "server_auth",
#  ]
#}