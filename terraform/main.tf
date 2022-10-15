module "loadbalancer" {
  count = local.applications.loadbalancer.enabled ? 1 : 0

  source    = "./loadbalancer"
  namespace = local.applications.loadbalancer.name
}

module "cert_manager" {
  count = local.applications.cert_manager.enabled ? 1 : 0

  source       = "./cert_manager"
  namespace    = local.applications.cert_manager.name
  CF_API_TOKEN = var.CF_API_TOKEN
}

module "ingress" {
  count = local.applications.ingress.enabled ? 1 : 0

  source    = "./ingress"
  namespace = local.applications.ingress.name

  depends_on = [module.loadbalancer]
}

module "nginx" {
  count = local.applications.nginx.enabled ? 1 : 0

  source    = "./nginx"
  namespace = local.applications.nginx.name

  depends_on = [module.ingress, module.cert_manager]
}


module "portfolio" {
  count = local.applications.portfolio.enabled ? 1 : 0

  source    = "./portfolio"
  namespace = local.applications.portfolio.name

  depends_on = [module.ingress]
}

