locals {
  applications = {
    dns = {
      name    = "dns"
      enabled = true
    }
    nfs = {
      name    = "nfs"
      enabled = true
      host    = "192.168.2.11"
      path    = "/var/nfs"
    }
    loadbalancer = {
      name          = "loadbalancer"
      address_range = "192.168.2.20-192.168.2.25"
      enabled       = true
    }
    ingress = {
      name                  = "ingress"
      enabled               = true
      CF_API_TOKEN      = var.CF_API_TOKEN
      CF_DOMAIN         = var.CF_DOMAIN
      CF_EMAIL          = var.CF_EMAIL
      TRAEFIK_DASHBOARD = var.TRAEFIK_DASHBOARD
    }
    // portfolio crashes cause traefik CRD are not defined yet
    portfolio = {
      name    = "portfolio"
      enabled = true
    }
    house_searching_notifier = {
      name    = "house-searching-notifier"
      enabled = true
    }
    monitoring = {
      name                 = "monitoring"
      enabled              = false
      GRAFANA_USER     = var.GRAFANA_USER
      GRAFANA_PASSWORD = var.GRAFANA_PASSWORD
    }
    github_runner = {
      name    = "github-runner"
      enabled = true
    }

    nginx = {
      name    = "nginx"
      enabled = false
    }
    torrente = {
      name                 = "torrente"
      enabled              = false
      OPENVPN_PASSWORD = var.OPENVPN_PASSWORD
      OPENVPN_USERNAME = var.OPENVPN_USERNAME
      puid                 = 65534
      pgid                 = 65534
      timezone             = "Europe/Amsterdam"
    }
    pihole = {
      name                = "pihole"
      enabled             = false
      PIHOLE_PASSWORD = var.PIHOLE_PASSWORD
    }
    wireguard = {
      name    = "wire-guard"
      enabled = false
    }
    file_manager = {
      name    = "file-manager"
      enabled = false
    }
    container_registry = {
      # not working!
      name    = "container-registry"
      enabled = false
    }
    continuous_deployment = {
      name    = "continuous-deployment"
      enabled = false
    }
  }
}
