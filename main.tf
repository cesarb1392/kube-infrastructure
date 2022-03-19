#module "monitoring" {
#  source = "./monitoring"
#  namespace = local.namespace.monitoring
#}

module "test" {
  source = "./test"
  namespace = local.namespace.test
}

module "loadbalancer" {
  source = "./loadbalancer"
  namespace = local.namespace.loadbalancer.name
  address_range = local.namespace.loadbalancer.address_range
}

#module "cert_manager" {
#  source = "./cert_manager"
#  namespace = local.namespace.cert_manager
#  cert_manager_name = "cert-manager"
#  cert_manager_repo = "https://charts.jetstack.io"
#  cert_manager_version = "1.0.4"
#}

