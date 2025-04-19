# resource "kubernetes_service_v1" "transmission2" {
#   metadata {
#     name      = "transmission2"
#     namespace = var.namespace
#     labels = {
#       namespace = var.namespace
#     }
#   }
#   spec {
#     port {
#       port        = 9000
#       target_port = kubernetes_deployment_v1.transmission.spec.0.template.0.spec.0.container.1.port.0.container_port
#       protocol    = "TCP"
#     }
#     selector = kubernetes_deployment_v1.transmission.spec.0.selector.0.match_labels
#   }
# }

# resource "kubernetes_service_v1" "jackett2" {
#   metadata {
#     name      = "jackett2"
#     namespace = var.namespace
#     labels = {
#       namespace = var.namespace
#     }
#   }
#   spec {
#     port {
#       port        = 9001
#       target_port = kubernetes_deployment_v1.jackett.spec.0.template.0.spec.0.container.1.port.0.container_port
#       name        = "http"
#     }
#     selector = kubernetes_deployment_v1.jackett.spec.0.selector.0.match_labels
#   }
# }

# resource "kubernetes_service_v1" "torrente_proxy" {
#   metadata {
#     name      = "torrente-proxy"
#     namespace = var.namespace
#     labels = {
#       namespace = var.namespace
#     }
#     annotations = {
#       "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-svc"
#       "metallb.io/ip-allocated-from-pool"   = "default"
#     }
#   }
#   spec {
#     load_balancer_ip = var.lan_ip
#     type             = "LoadBalancer"
#     port {
#       port        = 80
#       target_port = 80
#       protocol    = "TCP"
#     }
#     selector = kubernetes_deployment_v1.torrente_proxy.spec.0.selector.0.match_labels
#   }
# }

# resource "kubernetes_config_map" "torrente_proxy" {
#   metadata {
#     name      = "torrente-proxy"
#     namespace = var.namespace
#   }

#   data = {
#     "default.conf" = <<EOT
# server {
#   listen       80;
#   listen  [::]:80;
#   server_name  localhost;

#   proxy_hide_header X-Frame-Options; # this should allow iframe

#   location /transmission/ {
#     proxy_set_header    Host                 $host;
#     proxy_set_header    X-Forwarded-Proto    $scheme;
#     proxy_set_header    X-Forwarded-Protocol $scheme;
#     proxy_set_header    X-Real-IP            $remote_addr;
#     proxy_pass_header   X-Transmission-Session-Id;
#     proxy_set_header    X-Forwarded-Host     $host;
#     proxy_set_header    X-Forwarded-Server   $host;
#     proxy_set_header    X-Forwarded-For      $proxy_add_x_forwarded_for;
#     proxy_intercept_errors  on;
#     proxy_pass              http://transmission2.${var.namespace}.svc.cluster.local:9000;
#     proxy_read_timeout      600s;
#     proxy_send_timeout      600s;
#   }

#   location /jackett/ {
#     proxy_set_header    Host                 $host;
#     proxy_set_header    X-Forwarded-Proto    $scheme;
#     proxy_set_header    X-Forwarded-Protocol $scheme;
#     proxy_set_header    X-Real-IP            $remote_addr;
#     proxy_pass_header   X-Transmission-Session-Id;
#     proxy_set_header    X-Forwarded-Host     $host;
#     proxy_set_header    X-Forwarded-Server   $host;
#     proxy_set_header    X-Forwarded-For      $proxy_add_x_forwarded_for;
#     proxy_intercept_errors  on;
#     proxy_pass              http://jackett2.${var.namespace}.svc.cluster.local:9001;
#     proxy_read_timeout      600s;
#     proxy_send_timeout      600s;
#   }

#   location /sonarr/ {
#     proxy_set_header    Host                 $host;
#     proxy_set_header    X-Forwarded-Proto    $scheme;
#     proxy_set_header    X-Forwarded-Protocol $scheme;
#     proxy_set_header    X-Real-IP            $remote_addr;
#     proxy_pass_header   X-Transmission-Session-Id;
#     proxy_set_header    X-Forwarded-Host     $host;
#     proxy_set_header    X-Forwarded-Server   $host;
#     proxy_set_header    X-Forwarded-For      $proxy_add_x_forwarded_for;
#     proxy_intercept_errors  on;
#     proxy_pass              http://sonarr.${var.namespace}.svc.cluster.local:9003;
#     proxy_read_timeout      600s;
#     proxy_send_timeout      600s;
#   }

#   location /radarr/ {
#     proxy_set_header    Host                 $host;
#     proxy_set_header    X-Forwarded-Proto    $scheme;
#     proxy_set_header    X-Forwarded-Protocol $scheme;
#     proxy_set_header    X-Real-IP            $remote_addr;
#     proxy_pass_header   X-Transmission-Session-Id;
#     proxy_set_header    X-Forwarded-Host     $host;
#     proxy_set_header    X-Forwarded-Server   $host;
#     proxy_set_header    X-Forwarded-For      $proxy_add_x_forwarded_for;
#     proxy_intercept_errors  on;
#     proxy_pass              http://radarr.${var.namespace}.svc.cluster.local:9004;
#     proxy_read_timeout      600s;
#     proxy_send_timeout      600s;
#   }  
# }
# EOT
#   }
# }

#   # location / {
#   #   return 301 http://$server_name/transmission/;
#   # }

#   # location ^~ /jackett {
#   #   proxy_set_header        Host $host;
#   #   proxy_set_header        X-Real-IP $remote_addr;
#   #   proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
#   #   proxy_set_header        X-Forwarded-Proto $scheme;

#   #   proxy_pass              http://jackett.${var.namespace}.svc.cluster.local:${kubernetes_deployment_v1.jackett.spec.0.template.0.spec.0.container.1.port.0.container_port}/;

#   #   proxy_read_timeout      600s;
#   #   proxy_send_timeout      600s;
#   # }
# resource "kubernetes_deployment_v1" "torrente_proxy" {
#   metadata {
#     name      = "torrente-proxy"
#     namespace = var.namespace
#     labels = {
#       app = "torrente-proxy"
#     }
#   }
#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         app = "torrente-proxy"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "torrente-proxy"
#         }
#       }
#       spec {
#         container {
#           name              = "torrente-proxy"
#           image             = "nginx:1.19.0"
#           image_pull_policy = "IfNotPresent"
#           resources {
#             limits = {
#               memory = "50Mi"
#             }
#             requests = {
#               cpu    = "50m"
#               memory = "50Mi"
#             }
#           }
#           port {
#             container_port = 80
#           }
#           volume_mount {
#             name       = "torrente-proxy"
#             mount_path = "/etc/nginx/conf.d/default.conf"
#             sub_path   = "default.conf"
#           }
#         }
#         volume {
#           name = "torrente-proxy"
#           config_map {
#             name = "torrente-proxy"
#           }
#         }
#       }
#     }
#   }
# }
