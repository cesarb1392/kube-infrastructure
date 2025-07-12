# resource "helm_release" "longhorn" {
#   name             = "longhorn"
#   repository       = "https://charts.longhorn.io"
#   chart            = "longhorn"
#   namespace        = "longhorn-system"
#   version          = "v1.8.1"
#   create_namespace = true

#   set {
#     name  = "defaultSettings.defaultDataPath"
#     value = "/app/longhorn"
#   }

#   set {
#     name  = "defaultSettings.defaultReplicaCount"
#     value = "1"
#   }

#   set {
#     name  = "defaultSettings.replicaAutoBalance"
#     value = "least-effort"
#   }
#   set {
#     name  = "defaultSettings.storageOverProvisioningPercentage"
#     value = "100"
#   }

#   set {
#     name  = "defaultSettings.storageMinimalAvailablePercentage"
#     value = "15"
#   }

#   set {
#     name  = "defaultSettings.upgradeChecker"
#     value = "false"
#   }

#   set {
#     name  = "defaultSettings.autoSalvage"
#     value = "true"
#   }

#   set {
#     name  = "defaultSettings.disableSchedulingOnCordonedNode"
#     value = "true"
#   }

#   set {
#     name  = "csi.resizerReplicaCount"
#     value = "1"
#   }

#   set {
#     name  = "persistence.defaultClassReplicaCount"
#     value = "1"
#   }
#   # kubectl -n longhorn-system patch nodes.longhorn.io slowbanana --type=merge -p '{"spec": {"allowScheduling": false}}'
#   # kubectl -n longhorn-system patch nodes.longhorn.io mainbanana --type=merge -p '{"spec": {"allowScheduling": false}}'
#   # kubectl -n longhorn-system patch nodes.longhorn.io fastbanana --type=merge -p '{"spec": {"allowScheduling": true}}'
# }


resource "kubernetes_persistent_volume_claim" "this" {
  for_each = local.available_storage

  wait_until_bound = false
  metadata {
    name      = "${each.key}-pvc"
    namespace = each.key
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-path" # "longhorn" # 
    resources {
      requests = {
        storage = each.value.storage
      }
    }
  }
  depends_on = [kubernetes_namespace.this]
}

