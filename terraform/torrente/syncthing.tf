locals {
  app_name     = "syncthing"
  service_port = 80
}

resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name      = "${local.app_name}-reverse-proxy-nginx-config"
    namespace = var.namespace
  }

  data = {
    "default.conf" = <<EOT
server {
  listen       80;
  listen  [::]:80;
  server_name  localhost;

  location / {
    proxy_set_header        Host $host;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;

    proxy_pass              http://syncthing-service.${var.namespace}.svc.cluster.local:8384/;

    proxy_read_timeout      600s;
    proxy_send_timeout      600s;
  }
}
EOT
  }
}

resource "kubernetes_deployment_v1" "syncthing_reverse_proxy" {
  metadata {
    name      = "${local.app_name}-reverse-proxy"
    namespace = var.namespace
    labels = {
      app = "${local.app_name}-reverse-proxy"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${local.app_name}-reverse-proxy"
      }
    }

    template {
      metadata {
        labels = {
          app = "${local.app_name}-reverse-proxy"
        }
      }

      spec {
        container {
          name              = "${local.app_name}-reverse-proxy"
          image             = "nginx:1.19.0"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 80
          }
          volume_mount {
            name       = "nginx-config"
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path   = "default.conf"
          }
        }
        volume {
          name = "nginx-config"
          config_map {
            name = "${local.app_name}-reverse-proxy-nginx-config"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "syncthing" {
  metadata {
    name      = local.app_name
    namespace = var.namespace
    labels = {
      namespace = var.namespace
    }
    annotations = {
      "metallb.universe.tf/allow-shared-ip" = "${var.namespace}-svc"
      "metallb.io/ip-allocated-from-pool"   = "default"

    }
  }
  spec {
    load_balancer_ip = var.lan_ip
    type             = "LoadBalancer"
    port {
      port        = 9006
      target_port = kubernetes_deployment_v1.syncthing_reverse_proxy.spec.0.template.0.spec.0.container.0.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.syncthing_reverse_proxy.spec.0.selector.0.match_labels
  }
}


########################################################
########################################################
########################################################


resource "kubernetes_deployment" "syncthing" {
  metadata {
    name      = "syncthing"
    namespace = var.namespace
    labels = {
      app = "syncthing"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "syncthing"
      }
    }

    template {
      metadata {
        labels = {
          app = "syncthing"
        }
      }

      spec {
        container {
          name  = "syncthing"
          image = "linuxserver/syncthing"

          port {
            container_port = 8384
          }
          port {
            container_port = 22000
          }
          port {
            container_port = 21027
            protocol       = "UDP"
          }
          env {
            name  = "PUID"
            value = "1000"
          }
          env {
            name  = "GUID"
            value = "1003"
          }

          volume_mount {
            name       = "torrente"
            mount_path = "/config"
            sub_path   = "configs/syncthing"
          }
          volume_mount {
            name       = "torrente"
            mount_path = "/sync"
            sub_path   = "filebrowser"
          }
        }

        volume {
          name = "torrente"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "syncthing" {
  metadata {
    name      = "syncthing-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "syncthing"
    }
    port {
      name        = "webui"
      port        = 8384
      target_port = 8384
    }
    port {
      name        = "sync-tcp"
      port        = 22000
      target_port = 22000
    }
    port {
      name        = "sync-udp"
      port        = 21027
      target_port = 21027
    }
  }
}
