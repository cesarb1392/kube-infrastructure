locals {
  applications = {
    loadbalancer = {
      name    = "loadbalancer"
      enabled = true
    }
    cert_manager = {
      name    = "cert-manager"
      enabled = true
    }
    ingress = {
      name    = "ingress"
      enabled = true
    }
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
