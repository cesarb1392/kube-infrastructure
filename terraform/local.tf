locals {
  applications = {
    loadbalancer = {
      name          = "loadbalancer"
      address_range = "192.168.178.30-192.168.178.31"
      enabled       = true
    }
    ingress = {
      name         = "ingress"
      enabled      = true
    }
    // portfolio crashes cause traefik CRD are not defined yet
    portfolio = {
      name    = "portfolio"
      enabled = false
    }
    nginx = {
      name    = "nginx"
      enabled = true
    }
  }
}
