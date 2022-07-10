locals {
  registry_hostname = "registry.cesarb.dev"
  notary_hostname   = "notary.cesarb.dev"
  harbor_config = {
    #    https://github.com/goharbor/harbor-helm/blob/master/values.yaml
    "externalURL"                                                          = "https://${local.registry_hostname}"
    "expose.ingress.hosts.core"                                            = local.registry_hostname
    "expose.ingress.hosts.notary"                                          = local.notary_hostname
    "expose.ingress.annotations.kubernetes\\.io/ingress\\.class"           = "traefik"
    "harborAdminPassword"                                                  = "bananas"
    "metrics.enabled"                                                      = true
    "persistence.enabled"                                                  = true
    "registry.relativeurls"                                                = true
    "updateStrategy.type"                                                  = "Recreate"
    "persistence.imageChartStorage.persistentVolumeClaim.registry"         = kubernetes_persistent_volume_claim_v1.harbor_persistent_volume_claim.metadata[0].name
    "persistence.imageChartStorage.persistentVolumeClaim.registry.subPath" = "/registry"
    "persistence.imageChartStorage.persistentVolumeClaim.chartmuseum"      = kubernetes_persistent_volume_claim_v1.harbor_persistent_volume_claim.metadata[0].name
    "persistence.imageChartStorage.persistentVolumeClaim.registry.subPath" = "/chartmuseum"
  }
}
