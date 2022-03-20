locals {
  nginx = {
    name    = "nginx",
    enabled = true
  }
  loadbalancer = {
    name          = "loadbalancer"
    address_range = "192.168.2.20-192.168.2.25"
    enabled       = true
  }
  monitoring = {
    name    = "monitoring",
    enabled = true
  }
  ingress = {
    name    = "ingress",
    enabled = true
  }
}
