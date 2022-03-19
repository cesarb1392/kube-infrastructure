locals {
  namespace = {
    cert_manager = "cert_manager"
    test         = "test"
    loadbalancer = {
      name = "loadbalancer"
      address_range = "192.168.2.20-192.168.2.25"
    }
    monitoring   = "monitoring"
  }
}
