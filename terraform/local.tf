locals {
  applications = {
    loadbalancer = {
      name    = "loadbalancer"
      enabled = false
    }
    ingress = {
      name    = "ingress"
      enabled = false
    }
    nginx = {
      name    = "nginx"
      enabled = true
    }
  }
}
