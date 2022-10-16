module "ingress" {
  for_each = local.available_websites

  source    = "./ingress"
  namespace = each.key

  target_service = each.value.target_service
  ingress_port   = each.value.ingress_port
  hostname       = each.value.hostname

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

