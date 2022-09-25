module "loadbalancer" {
  count = local.applications.loadbalancer.enabled ? 1 : 0

  source        = "./loadbalancer"
  namespace     = local.applications.loadbalancer.name
  address_range = local.applications.loadbalancer.address_range

}

module "ingress" {
  count = local.applications.ingress.enabled ? 1 : 0

  source       = "./ingress"
  namespace    = local.applications.ingress.name

}

module "nginx" {
  count = local.applications.nginx.enabled ? 1 : 0

  source    = "./nginx"
  namespace = local.applications.nginx.name

  depends_on = [module.ingress]
}