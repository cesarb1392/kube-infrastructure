module "monitoring" {
  source = "./monitoring"
  namespace = local.namespace.monitoring
}

module "test" {
  source = "./test"
  namespace = local.namespace.test
}
