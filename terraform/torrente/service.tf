resource "kubernetes_service_v1" "transmission" {
  metadata {
    name      = "transmission"
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
      port        = 9000
      target_port = kubernetes_deployment_v1.transmission.spec.0.template.0.spec.0.container.1.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.transmission.spec.0.selector.0.match_labels
  }
}

resource "kubernetes_service_v1" "jackett" {
  metadata {
    name      = "jackett"
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
      port        = 9001
      target_port = kubernetes_deployment_v1.jackett.spec.0.template.0.spec.0.container.1.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.jackett.spec.0.selector.0.match_labels
  }
}

resource "kubernetes_service_v1" "prowlarr" {
  metadata {
    name      = "prowlarr"
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
      port        = 9002
      target_port = kubernetes_deployment_v1.prowlarr.spec.0.template.0.spec.0.container.0.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.prowlarr.spec.0.selector.0.match_labels
  }
}

resource "kubernetes_service_v1" "sonarr" {
  metadata {
    name      = "sonarr"
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
      port        = 9003
      target_port = kubernetes_deployment_v1.sonarr.spec.0.template.0.spec.0.container.0.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.sonarr.spec.0.selector.0.match_labels
  }
}

resource "kubernetes_service_v1" "radarr" {
  metadata {
    name      = "radarr"
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
      port        = 9004
      target_port = kubernetes_deployment_v1.radarr.spec.0.template.0.spec.0.container.0.port.0.container_port
      name        = "http"
    }
    selector = kubernetes_deployment_v1.radarr.spec.0.selector.0.match_labels
  }
}

# resource "kubernetes_service_v1" "filebrowser" {
#   metadata {
#     name      = "filebrowser"
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
#       port        = 9005
#       target_port = kubernetes_deployment_v1.filebrowser.spec.0.template.0.spec.0.container.0.port.0.container_port
#       name        = "http"
#     }
#     selector = kubernetes_deployment_v1.filebrowser.spec.0.selector.0.match_labels
#   }
# }


# resource "kubernetes_service_v1" "syncthing" {
#   metadata {
#     name      = local.syncthing_name
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
#       port        = 9006
#       target_port = kubernetes_deployment_v1.syncthing_reverse_proxy.spec.0.template.0.spec.0.container.0.port.0.container_port
#       name        = "http"
#     }
#     selector = kubernetes_deployment_v1.syncthing_reverse_proxy.spec.0.selector.0.match_labels
#   }
# }

# resource "kubernetes_service" "syncthing" {
#   metadata {
#     name      = "syncthing-service"
#     namespace = var.namespace
#   }

#   spec {
#     selector = {
#       app = "syncthing"
#     }
#     port {
#       name        = "webui"
#       port        = 8384
#       target_port = 8384
#     }
#     port {
#       name        = "sync-tcp"
#       port        = 22000
#       target_port = 22000
#     }
#     port {
#       name        = "sync-udp"
#       port        = 21027
#       target_port = 21027
#     }
#   }
# }
