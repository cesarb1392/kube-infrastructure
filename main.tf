#module "cert_manager" {
#  source = "./cert_manager"
#  namespace = local.namespace.cert_manager
#}

module "metallb" {
  source        = "./metallb"
  namespace     = local.namespace.metallb.name
  address_range = local.namespace.metallb.address_range
}

module "traefik" {
  source    = "./traefik"
  namespace = local.namespace.traefik.name
  dashboard_ingress = local.namespace.traefik.dashboard_ingress
}

module "nginx" {
  source    = "./nginx"
  namespace = local.namespace.nginx
}

#module "monitoring" {
#  source = "./monitoring"
#  namespace = local.namespace.monitoring
#}
