# https://github.com/Place1/wg-access-server/blob/master/deploy/helm/wg-access-server/values.yaml

data "template_file" "wireguard" {
  template = yamlencode({
    web = {
      config = {
        adminUsername = "platano"
        adminPassword = "banana12345"
      }
      service = {
        type           = "LoadBalancer"
        loadBalancerIP = "192.168.178.230"
        annotations = {
          "metallb.universe.tf/allow-shared-ip" = "wireguard-wg-access"
        }
      }
    }
    wireguard = {
      config = {
        privateKey = var.private_key
      }
      service = {
        type           = "LoadBalancer"
        loadBalancerIP = "192.168.178.230"
        annotations = {
          "metallb.universe.tf/allow-shared-ip" = "wireguard-wg-access"
        }
      }
    }
  })
}


resource "helm_release" "wireguard" {
  name       = var.namespace
  namespace  = var.namespace
  chart      = "wg-access-server"
  repository = "https://place1.github.io/wg-access-server"
  values     = [data.template_file.wireguard.rendered]

}

