module "loadbalancer" {
  count = local.applications.loadbalancer.enabled ? 1 : 0

  source        = "./loadbalancer"
  namespace     = local.applications.loadbalancer.name
  address_range = local.applications.loadbalancer.address_range

}

module "ingress" {
  count = local.applications.ingress.enabled ? 1 : 0

  source                = "./ingress"
  namespace             = local.applications.ingress.name
  CF_API_TOKEN      = local.applications.ingress.CF_API_TOKEN
  CF_DOMAIN         = local.applications.ingress.CF_DOMAIN
  CF_EMAIL          = local.applications.ingress.CF_EMAIL
  TRAEFIK_DASHBOARD = local.applications.ingress.TRAEFIK_DASHBOARD

  depends_on = [module.nfs]
}

module "nfs" {
  count = local.applications.nfs.enabled ? 1 : 0

  source    = "./nfs"
  namespace = local.applications.nfs.name
  nfs_host  = local.applications.nfs.host
  nfs_path  = local.applications.nfs.path

  depends_on = [kubernetes_namespace.this]
}

module "nginx" {
  count = local.applications.nginx.enabled ? 1 : 0

  source    = "./nginx"
  namespace = local.applications.nginx.name

  depends_on = [module.ingress, module.loadbalancer]
}

module "monitoring" {
  count = local.applications.monitoring.enabled ? 1 : 0

  source               = "./monitoring"
  namespace            = local.applications.monitoring.name
  GRAFANA_USER     = local.applications.monitoring.GRAFANA_USER
  GRAFANA_PASSWORD = local.applications.monitoring.GRAFANA_PASSWORD

  depends_on = [module.nfs]
}

module "portfolio" {
  count = local.applications.portfolio.enabled ? 1 : 0

  source    = "./portfolio"
  namespace = local.applications.portfolio.name

  depends_on = [module.ingress, module.loadbalancer]
}

module "torrente" {
  count = local.applications.torrente.enabled ? 1 : 0

  source               = "./torrente"
  namespace            = local.applications.torrente.name
  OPENVPN_PASSWORD = local.applications.torrente.OPENVPN_PASSWORD
  OPENVPN_USERNAME = local.applications.torrente.OPENVPN_USERNAME
  pgid                 = local.applications.torrente.pgid
  puid                 = local.applications.torrente.puid
  timezone             = local.applications.torrente.timezone

  depends_on = [module.nfs, module.ingress, module.loadbalancer]
}

module "pi_hole" {
  count = local.applications.pihole.enabled ? 1 : 0

  source              = "./pi_hole"
  namespace           = local.applications.pihole.name
  PIHOLE_PASSWORD = local.applications.pihole.PIHOLE_PASSWORD

  depends_on = [module.nfs, module.ingress, module.loadbalancer]
}

module "wireguard" {
  count = local.applications.wireguard.enabled ? 1 : 0

  source    = "./wire_guard"
  namespace = local.applications.wireguard.name

  depends_on = [module.nfs, module.ingress, module.loadbalancer]
}

module "file_manager" {
  count = local.applications.file_manager.enabled ? 1 : 0

  source    = "./file_manager"
  namespace = local.applications.file_manager.name

  depends_on = [module.nfs]
}

module "container_registry" {
  count = local.applications.container_registry.enabled ? 1 : 0

  source    = "./container_registry"
  namespace = local.applications.container_registry.name

  depends_on = [module.nfs, module.ingress, module.loadbalancer]
}

module "continuous_deployment" {
  count = local.applications.continuous_deployment.enabled ? 1 : 0

  source    = "./continuous_deployment"
  namespace = local.applications.continuous_deployment.name

  depends_on = [module.nfs, module.ingress, module.loadbalancer]
}

module "house_searching_notifier" {
  count = local.applications.house_searching_notifier.enabled ? 1 : 0

  source    = "./house_searching_notifier"
  namespace = local.applications.house_searching_notifier.name

  CLIENT_ID       = var.CLIENT_ID
  CLIENT_SECRET   = var.CLIENT_SECRET
  EMAIL_FROM      = var.EMAIL_FROM
  EMAIL_TO        = var.EMAIL_TO
  REFRESH_TOKEN   = var.REFRESH_TOKEN
  SCRAPE_URL_BUY  = var.SCRAPE_URL_BUY
  SCRAPE_URL_RENT = var.SCRAPE_URL_RENT

  depends_on = [module.ingress, module.loadbalancer]
}

module "github_runner" {
  count = local.applications.github_runner.enabled ? 1 : 0

  source    = "./github_runner"
  namespace = local.applications.github_runner.name

  ACCESS_TOKEN   = var.ACCESS_TOKEN
  REPO_URL       = var.REPO_URL
  RUNNER_WORKDIR = var.RUNNER_WORKDIR
  RUNNER_NAME    = var.RUNNER_NAME

  depends_on = [module.nfs]
}
