locals {
  applications = {
    loadbalancer = {
      name    = "loadbalancer"
      enabled = false
    }
    cert_manager = {
      name    = "cert-manager"
      enabled = true
    }
    ingress = {
      name    = "ingress"
      enabled = false
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
