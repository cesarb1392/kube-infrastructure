##########################
##### PUBLIC NETWORK #####
##########################

module "ingress" {
  for_each = local.available_ingresses

  source    = "./public_ingress"
  namespace = each.key

  target_service = each.value.target_service
  ingress_port   = each.value.ingress_port
  hostname       = each.key
  cf_access      = can(each.value.cf_access) ? each.value.cf_access : false

  CF_ACCOUNT_ID = var.CF_ACCOUNT_ID
  CF_ZONE_ID    = var.CF_ZONE_ID
  CF_ZONE_NAME  = var.CF_ZONE_NAME

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

module "minio" {
  count = local.applications.minio.enabled ? 1 : 0

  source = "./minio"

  namespace           = "minio"
  app_name            = "minio"
  ingress_port        = local.applications.minio.ingress_port
  target_service      = local.applications.minio.target_service
  MINIO_USERS         = var.MINIO_USERS
  MINIO_ROOT_PASSWORD = var.MINIO_ROOT_PASSWORD
  MINIO_ROOT_USER     = var.MINIO_ROOT_USER
}

module "wireguard" {
  count = local.applications.wireguard.enabled ? 1 : 0

  source         = "./wireguard"
  namespace      = "wireguard"
  ingress_port   = local.applications.wireguard.ingress_port
  target_service = local.applications.wireguard.target_service
  CF_ZONE_NAME   = var.CF_ZONE_NAME
  TZ             = var.TZ

  depends_on = [module.ingress]
}


##########################
#### PRIVATE NETWORK #####
##########################


module "metallb" {
  count = local.applications.metallb.enabled ? 1 : 0

  source    = "./metallb"
  namespace = "metallb"

  log_level = local.applications.metallb.log_level

  depends_on = [kubernetes_namespace.this]
}

module "private_ingress" {
  count = local.applications.privateingress.enabled ? 1 : 0

  source    = "./private_ingress"
  namespace = "privateingress"

  depends_on = [kubernetes_namespace.this]
}

module "pihole" {
  count = local.applications.pihole.enabled ? 1 : 0

  source    = "./pihole"
  namespace = "pihole"
  TZ        = var.TZ

  depends_on = [module.ingress, module.metallb]
  password   = var.PI_HOLE_PASS
}