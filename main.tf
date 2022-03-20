#module "cert_manager" {
#  source = "./cert_manager"
#  namespace = local.namespace.cert_manager
#}

module "loadbalancer" {
  source        = "./loadbalancer"
  namespace     = local.namespace.loadbalancer.name
  address_range = local.namespace.loadbalancer.address_range
}

module "ingress" {
  source    = "./ingress"
  namespace = local.namespace.ingress
}

module "nginx" {
  source    = "./nginx"
  namespace = local.namespace.nginx
}

#module "monitoring" {
#  source = "./monitoring"
#  namespace = local.namespace.monitoring
#}
