locals {
  namespace = {
    monitoring = "monitoring"
    cert_manager = "certmanager"
    nginx        = "nginx"
    metallb = {
      name          = "metallb"
      address_range = "192.168.2.20-192.168.2.25"
    }
    traefik    = {
      name = "traefik"
      dashboard_ingress = 1
    }
  }
}
