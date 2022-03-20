module "loadbalancer" {
  count         = local.loadbalancer.enabled ? 1 : 0
  source        = "./loadbalancer"
  namespace     = local.loadbalancer.name
  address_range = local.loadbalancer.address_range
}

module "ingress" {
  count                 = local.ingress.enabled ? 1 : 0
  source                = "./ingress"
  namespace             = local.ingress.name
  K3S_CF_API_KEY        = var.K3S_CF_API_KEY
  K3S_CF_DOMAIN         = var.K3S_CF_DOMAIN
  K3S_CF_EMAIL          = var.K3S_CF_EMAIL
  K3S_TRAEFIK_DASHBOARD = var.K3S_TRAEFIK_DASHBOARD
}

module "nginx" {
  count     = local.nginx.enabled ? 1 : 0
  source    = "./nginx"
  namespace = local.nginx.name
}

module "monitoring" {
  count                = local.monitoring.enabled ? 1 : 0
  source               = "./monitoring"
  namespace            = local.monitoring.name
  K3S_GRAFANA_USER     = var.K3S_GRAFANA_USER
  K3S_GRAFANA_PASSWORD = var.K3S_GRAFANA_PASSWORD
}
