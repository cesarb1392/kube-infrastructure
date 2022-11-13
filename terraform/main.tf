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

  source      = "./wireguard"
  namespace   = "wireguard"
  private_key = var.WG_PRIVATE_KEY
  password    = var.WG_PASSWORD
  user        = var.WG_USER

  depends_on = [module.metallb]
  host_ip    = local.applications.wireguard.host_ip
}


module "metallb" {
  count = local.applications.metallb.enabled ? 1 : 0

  source    = "./metallb"
  namespace = "metallb"

  log_level = local.applications.metallb.log_level

  depends_on   = [kubernetes_namespace.this]
  address_pool = local.applications.metallb.address_pool
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

  depends_on = [module.ingress, module.metallb]
  host_ip    = local.applications.pihole.host_ip
}

module "monitoring" {
  count = local.applications.monitoring.enabled ? 1 : 0

  source    = "./monitoring"
  namespace = "monitoring"
  TZ        = var.TZ

  depends_on = [module.metallb]
}

module "loadtest" {
  count = local.applications.loadtest.enabled ? 1 : 0

  source     = "./load_test"
  namespace  = "loadtest"
  target_url = local.applications.loadtest.target_url
}

module "github_runner" {
  count = local.applications.github_runner.enabled ? 1 : 0

  source    = "./github_runner"
  namespace = "github-runner"

  ACCESS_TOKEN = var.GH_ACCESS_TOKEN
  RUNNER_NAME  = "bananaRunner"
  repositories = local.applications.github_runner.repos
}