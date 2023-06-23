module "ingress" { # replace by public_ingress
  for_each = local.public_ingress

  source    = "./public_ingress"
  namespace = each.key

  target_service = each.value.target_service
  ingress_port   = each.value.ingress_port
  hostname       = each.key
  cf_access      = can(each.value.cf_access) ? each.value.cf_access : false

  CF_ACCOUNT_ID        = var.CF_ACCOUNT_ID
  CF_ZONE_ID           = var.CF_ZONE_ID
  CF_ZONE_NAME         = var.CF_ZONE_NAME
  CF_ACCESS_EMAIL_LIST = var.CF_ACCESS_EMAIL_LIST

  depends_on = [kubernetes_namespace.this]
}

module "website" {
  for_each = local.available_websites

  source         = "./website"
  namespace      = each.key
  app_name       = each.key
  app_image      = each.value.image
  target_service = each.value.target_service
  ingress_port   = each.value.ingress_port

  depends_on = [module.ingress]
}

module "metallb" {
  count = local.applications.metallb.enabled ? 1 : 0

  source       = "./metallb"
  namespace    = "metallb"
  log_level    = local.applications.metallb.log_level
  address_pool = local.applications.metallb.address_pool

  depends_on = [kubernetes_namespace.this]
}

module "private_ingress" {
  count = local.applications.privateingress.enabled ? 1 : 0

  source    = "./private_ingress"
  namespace = "private-ingress"

  depends_on = [kubernetes_namespace.this]
}

module "pihole" {
  count = local.applications.pihole.enabled ? 1 : 0

  source    = "./pihole"
  namespace = "pihole"
  password  = var.PI_HOLE_PASS
  TZ        = var.TZ
  lan_ip    = local.applications.pihole.lan_ip

  depends_on = [module.ingress, module.metallb]

}

module "monitoring" {
  count = local.applications.monitoring.enabled ? 1 : 0

  source    = "./monitoring"
  namespace = "monitoring"
  TZ        = var.TZ
  available = local.applications.monitoring.available
  puid      = var.PUID
  pgid      = var.PGID
  lan_ip    = local.applications.monitoring.lan_ip
  #  prometheus_pvc_name = kubernetes_persistent_volume_claim.this["monitoring"].metadata.0.name

  depends_on = [module.metallb]
}

module "loadtest" {
  count = local.applications.loadtest.enabled ? 1 : 0

  source     = "./load_test"
  namespace  = "loadtest"
  target_url = local.applications.loadtest.target_url

  depends_on = [kubernetes_namespace.this]
}

module "github_runner" {
  count = local.applications.githubrunner.enabled ? 1 : 0

  source    = "./github_runner"
  namespace = "githubrunner"

  ACCESS_TOKEN = var.GH_ACCESS_TOKEN
  repositories = local.applications.githubrunner.repos

  depends_on = [kubernetes_namespace.this]
}

module "minio" {
  count = local.applications.minio.enabled ? 1 : 0

  source = "./minio"

  namespace                    = "minio"
  app_name                     = "minio"
  ingress_port                 = local.applications.minio.ingress_port
  target_service               = local.applications.minio.target_service
  MINIO_USERS                  = var.MINIO_USERS
  MINIO_ROOT_PASSWORD          = var.MINIO_ROOT_PASSWORD
  MINIO_ROOT_USER              = var.MINIO_ROOT_USER
  persistent_volume_claim_name = kubernetes_persistent_volume_claim.this["minio"].metadata.0.name
}

module "wireguard" {
  count = local.applications.wireguard.enabled ? 1 : 0

  source                       = "./wireguard"
  namespace                    = "wireguard"
  private_key                  = var.WG_PRIVATE_KEY
  password                     = var.WG_PASSWORD
  user                         = var.WG_USER
  lan_ip                       = local.applications.wireguard.lan_ip
  log_level                    = local.applications.wireguard.log_level
  persistent_volume_claim_name = kubernetes_persistent_volume_claim.this["wireguard"].metadata.0.name
  depends_on                   = [module.metallb]
  CF_ZONE_ID                   = var.CF_ZONE_ID
}

module "vaultwarden" {
  count = local.applications.vaultwarden.enabled ? 1 : 0

  source                       = "./vaultwarden"
  namespace                    = "vaultwarden"
  ingress_port                 = local.applications.vaultwarden.ingress_port
  SERVER_ADMIN_EMAIL           = var.CF_ACCESS_EMAIL_LIST.0
  DOMAIN                       = var.CF_ZONE_NAME
  VAULTWARDEN_ADMIN_TOKEN      = var.VAULTWARDEN_ADMIN_TOKEN
  persistent_volume_claim_name = kubernetes_persistent_volume_claim.this["vaultwarden"].metadata.0.name
  log_level                    = local.applications.vaultwarden.log_level

  depends_on = [kubernetes_namespace.this, module.ingress]
}

module "picamera" {
  count = local.applications.picamera.enabled ? 1 : 0

  source       = "./picamera"
  namespace    = "picamera"
  ingress_port = local.applications.picamera.ingress_port

  depends_on = [kubernetes_namespace.this, module.ingress]
}

module "torrenteold" {
  count = local.applications.torrenteold.enabled ? 1 : 0

  source = "./torrenteold"

  namespace                    = "torrenteold"
  OPENVPN_PASSWORD             = var.OPENVPN_PASSWORD
  OPENVPN_USERNAME             = var.OPENVPN_USERNAME
  puid                         = var.PUID
  pgid                         = var.PGID
  timezone                     = var.TZ
  lan_ip                       = local.applications.torrente.lan_ip
  persistent_volume_claim_name = kubernetes_persistent_volume_claim.this["torrenteold"].metadata.0.name

  depends_on = [kubernetes_namespace.this]
}

module "torrente" {
  count = local.applications.torrente.enabled ? 1 : 0

  source = "./torrente"

  namespace                    = "torrente"
  PRIVATE_KEY                  = var.OPENVPN_PRIVATE_KEY
  puid                         = var.PUID
  pgid                         = var.PGID
  timezone                     = var.TZ
  lan_ip                       = local.applications.torrente.lan_ip
  vpn_country_code             = var.vpn_country_code
  persistent_volume_claim_name = kubernetes_persistent_volume_claim.this["torrente"].metadata.0.name

  depends_on = [kubernetes_namespace.this]
}
