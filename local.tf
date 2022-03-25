locals {
  nginx = {
    name    = "nginx"
    enabled = true
  }
  loadbalancer = {
    name          = "loadbalancer"
    address_range = "192.168.2.20-192.168.2.25"
    enabled       = true
  }
  monitoring = {
    name                 = "monitoring"
    enabled              = true
    K3S_GRAFANA_USER     = var.K3S_GRAFANA_USER
    K3S_GRAFANA_PASSWORD = var.K3S_GRAFANA_PASSWORD
  }
  ingress = {
    name                  = "ingress"
    enabled               = true
    K3S_CF_API_KEY        = var.K3S_CF_API_KEY
    K3S_CF_DOMAIN         = var.K3S_CF_DOMAIN
    K3S_CF_EMAIL          = var.K3S_CF_EMAIL
    K3S_TRAEFIK_DASHBOARD = var.K3S_TRAEFIK_DASHBOARD
  }
  portfolio = {
    name    = "portfolio"
    enabled = true
  }
  nfs = {
    name     = "nfs"
    enabled  = true
    nfs_host = "192.168.2.11" # todo: works if the pod is assigned to fastbanana2 node only!!!
    nfs_path = "/var/nfs"
  }
  #  false   true
  torrente = {
    name                 = "torrente"
    enabled              = true
    K3S_OPENVPN_PASSWORD = var.K3S_OPENVPN_PASSWORD
    K3S_OPENVPN_USERNAME = var.K3S_OPENVPN_USERNAME
    puid                 = 65534
    pgid                 = 65534
    timezone             = "Europe/Amsterdam"
  }
}
