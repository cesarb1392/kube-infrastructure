locals {
  namespace = {
    cert_manager = "certmanager"
    nginx        = "nginx"
    loadbalancer = {
      name          = "loadbalancer"
      address_range = "192.168.2.20-192.168.2.25"
    }
    monitoring = "monitoring"
    ingress    = "ingress"
  }
}
