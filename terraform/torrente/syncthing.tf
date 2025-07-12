# locals {
#   syncthing_name = "syncthing"
#   service_port   = 80
# }

# resource "kubernetes_config_map" "nginx_config" {
#   metadata {
#     name      = "${local.syncthing_name}-reverse-proxy-nginx-config"
#     namespace = var.namespace
#   }

#   data = {
#     "default.conf" = <<EOT
# server {
#   listen       80;
#   listen  [::]:80;
#   server_name  localhost;

#   location / {
#     proxy_set_header        Host $host;
#     proxy_set_header        X-Real-IP $remote_addr;
#     proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
#     proxy_set_header        X-Forwarded-Proto $scheme;

#     proxy_pass              http://syncthing-service.${var.namespace}.svc.cluster.local:8384/;

#     proxy_read_timeout      600s;
#     proxy_send_timeout      600s;
#   }
# }
# EOT
#   }
# }

# resource "kubernetes_deployment_v1" "syncthing_reverse_proxy" {
#   metadata {
#     name      = "${local.syncthing_name}-reverse-proxy"
#     namespace = var.namespace
#     labels = {
#       app = "${local.syncthing_name}-reverse-proxy"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "${local.syncthing_name}-reverse-proxy"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "${local.syncthing_name}-reverse-proxy"
#         }
#       }

#       spec {
#         container {
#           name              = "${local.syncthing_name}-reverse-proxy"
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
#             name       = "nginx-config"
#             mount_path = "/etc/nginx/conf.d/default.conf"
#             sub_path   = "default.conf"
#           }
#         }
#         volume {
#           name = "nginx-config"
#           config_map {
#             name = "${local.syncthing_name}-reverse-proxy-nginx-config"
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_deployment" "syncthing" {
#   metadata {
#     name      = "syncthing"
#     namespace = var.namespace
#     labels = {
#       app = "syncthing"
#     }
#   }

#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         app = "syncthing"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "syncthing"
#         }
#       }
#       spec {
#         container {
#           name  = "syncthing"
#           image = "linuxserver/syncthing"
#           resources {
#             limits = {
#               memory = "400Mi"
#             }
#             requests = {
#               cpu    = "200m"
#               memory = "400Mi"
#             }
#           }
#           port {
#             container_port = 8384
#           }
#           port {
#             container_port = 22000
#           }
#           port {
#             container_port = 21027
#             protocol       = "UDP"
#           }
#           env {
#             name  = "PUID"
#             value = "1000"
#           }
#           env {
#             name  = "GUID"
#             value = "1003"
#           }

#           volume_mount {
#             name       = "torrente"
#             mount_path = "/config"
#             sub_path   = "configs/syncthing"
#           }
#           volume_mount {
#             name       = "torrente"
#             mount_path = "/sync"
#             sub_path   = "filebrowser"
#           }
#         }

#         volume {
#           name = "torrente"
#           persistent_volume_claim {
#             claim_name = var.persistent_volume_claim_name
#           }
#         }
#       }
#     }
#   }
# }

