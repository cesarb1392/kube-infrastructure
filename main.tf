module "loadbalancer" {
  count = local.applications.loadbalancer.enabled ? 1 : 0

  source        = "./loadbalancer"
  namespace     = local.applications.loadbalancer.name
  address_range = local.applications.loadbalancer.address_range

  depends_on = [kubernetes_namespace.this]
}

module "ingress" {
  count = local.applications.ingress.enabled ? 1 : 0

  source                = "./ingress"
  namespace             = local.applications.ingress.name
  K3S_CF_API_KEY        = local.applications.ingress.K3S_CF_API_KEY
  K3S_CF_DOMAIN         = local.applications.ingress.K3S_CF_DOMAIN
  K3S_CF_EMAIL          = local.applications.ingress.K3S_CF_EMAIL
  K3S_TRAEFIK_DASHBOARD = local.applications.ingress.K3S_TRAEFIK_DASHBOARD

  depends_on = [kubernetes_namespace.this]

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

  depends_on = [kubernetes_namespace.this]
}

module "monitoring" {
  count = local.applications.monitoring.enabled ? 1 : 0

  source               = "./monitoring"
  namespace            = local.applications.monitoring.name
  K3S_GRAFANA_USER     = local.applications.monitoring.K3S_GRAFANA_USER
  K3S_GRAFANA_PASSWORD = local.applications.monitoring.K3S_GRAFANA_PASSWORD

  depends_on = [kubernetes_namespace.this]
}

module "portfolio" {
  count = local.applications.portfolio.enabled ? 1 : 0

  source    = "./portfolio"
  namespace = local.applications.portfolio.name

  depends_on = [kubernetes_namespace.this]
}

module "torrente" {
  count = local.applications.torrente.enabled ? 1 : 0

  source               = "./torrente"
  namespace            = local.applications.torrente.name
  K3S_OPENVPN_PASSWORD = local.applications.torrente.K3S_OPENVPN_PASSWORD
  K3S_OPENVPN_USERNAME = local.applications.torrente.K3S_OPENVPN_USERNAME
  pgid                 = local.applications.torrente.pgid
  puid                 = local.applications.torrente.puid
  timezone             = local.applications.torrente.timezone

  depends_on = [kubernetes_namespace.this]
}

module "pi_hole" {
  count = local.applications.pihole.enabled ? 1 : 0

  source              = "./pi_hole"
  namespace           = local.applications.pihole.name
  K3S_PIHOLE_PASSWORD = local.applications.pihole.K3S_PIHOLE_PASSWORD

  depends_on = [kubernetes_namespace.this]
}

module "wireguard" {
  count = local.applications.wireguard.enabled ? 1 : 0

  source    = "./wire_guard"
  namespace = local.applications.wireguard.name

  depends_on = [kubernetes_namespace.this]
}

module "file_manager" {
  count = local.applications.file_manager.enabled ? 1 : 0

  source    = "./file_manager"
  namespace = local.applications.file_manager.name

  depends_on = [kubernetes_namespace.this]
}

module "dns" {
  count = local.applications.dns.enabled ? 1 : 0

  source    = "./dns"
  namespace = local.applications.dns.name

  depends_on = [kubernetes_namespace.this]
}

module "container_registry" {
  count = local.applications.container_registry.enabled ? 1 : 0

  source    = "./container_registry"
  namespace = local.applications.container_registry.name

  depends_on = [kubernetes_namespace.this]
}
