module "loadbalancer" {
  count = local.loadbalancer.enabled ? 1 : 0

  source        = "./loadbalancer"
  namespace     = local.loadbalancer.name
  address_range = local.loadbalancer.address_range
}

module "ingress" {
  count = local.ingress.enabled ? 1 : 0

  source                = "./ingress"
  namespace             = local.ingress.name
  K3S_CF_API_KEY        = local.ingress.K3S_CF_API_KEY
  K3S_CF_DOMAIN         = local.ingress.K3S_CF_DOMAIN
  K3S_CF_EMAIL          = local.ingress.K3S_CF_EMAIL
  K3S_TRAEFIK_DASHBOARD = local.ingress.K3S_TRAEFIK_DASHBOARD
}

module "nfs" {
  count = local.nfs.enabled ? 1 : 0

  source    = "./nfs"
  namespace = local.nfs.name
  nfs_host  = local.nfs.nfs_host
  nfs_path  = local.nfs.nfs_path
}

module "nginx" {
  count = local.nginx.enabled ? 1 : 0

  source    = "./nginx"
  namespace = local.nginx.name
}

module "monitoring" {
  count = local.monitoring.enabled ? 1 : 0

  source               = "./monitoring"
  namespace            = local.monitoring.name
  K3S_GRAFANA_USER     = local.monitoring.K3S_GRAFANA_USER
  K3S_GRAFANA_PASSWORD = local.monitoring.K3S_GRAFANA_PASSWORD
}

module "portfolio" {
  count = local.portfolio.enabled ? 1 : 0

  source    = "./portfolio"
  namespace = local.portfolio.name
}

module "torrente" {
  count = local.torrente.enabled ? 1 : 0

  source               = "./torrente"
  namespace            = local.torrente.name
  K3S_OPENVPN_PASSWORD = local.torrente.K3S_OPENVPN_PASSWORD
  K3S_OPENVPN_USERNAME = local.torrente.K3S_OPENVPN_USERNAME
  pgid                 = local.torrente.pgid
  puid                 = local.torrente.puid
  timezone             = local.torrente.timezone
}
