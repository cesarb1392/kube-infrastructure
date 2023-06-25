#https://docs.k8s-at-home.com/guides/pod-gateway/#pod-gateway-helm-release

locals {
  pod_gateway_values = {
    image = {
      repository = "ghcr.io/angelnu/pod-gateway"
      tag        = "v1.8.1"
    }
    webhook = {
      image = {
        repository = "ghcr.io/angelnu/gateway-admision-controller"
        tag        = "v3.9.0"
      }
      namespaceSelector = {
        type  = "label"
        label = "routed-gateway"
      }
      gatewayDefault = true
      gatewayLabel   = "setGateway"
    }
    addons = {
      vpn = {
        enabled = true
        type    = "gluetun"
        gluetun = {
          image = {
            repository = "docker.io/qmcgaw/gluetun"
            tag        = "latest"
          }
        }
        env = [
          {
            name  = "VPN_SERVICE_PROVIDER"
            value = "nordvpn"
          },
          {
            name  = "WIREGUARD_PRIVATE_KEY"
            value = var.PRIVATE_KEY
          },
          {
            name  = "SERVER_COUNTRIES"
            value = var.vpn_country
          },
          {
            name  = "VPN_TYPE"
            value = "wireguard"
          },
          {
            name  = "VPN_INTERFACE"
            value = "wg0"
          },
          {
            name  = "FIREWALL"
            value = "off"
          },
          {
            name  = "DOT"
            value = "off"
          },
          {
            name  = "DNS_KEEP_NAMESERVER"
            value = "on"
          }
        ]
        networkPolicy = {
          enabled = true
          egress = [
            {
              to = [
                { ipBlock = { cidr = "0.0.0.0/0" } }
              ]
              ports = [
                {
                  port     = 51820
                  protocol = "UDP"
                }
              ]
            },
            {
              to = [
                { ipBlock = { cidr = "10.0.0.0/8" } }
              ]
            }
          ]
        }
      }
    }
    settings = {
      VPN_INTERFACE               = "wg0"
      VPN_BLOCK_OTHER_TRAFFIC     = true
      VPN_TRAFFIC_PORT            = 51820
      VPN_LOCAL_CIDRS             = "10.0.0.0/8 192.168.178.0/24" #  K8S lan and local home CIDRs
      NOT_ROUTED_TO_GATEWAY_CIDRS = "10.42.0.0/16 10.43.0.0/16"   # with your cluster cidr and service cidrs.
    }
    publicPorts = [
      {
        hostname = "transmission" # pod name
        IP       = 10
        ports = [
          {
            type = "udp"
            port = 51413
          },
          {
            type = "tcp"
            port = 51413
          }
        ]
      }
    ]
  }
}

resource "helm_release" "pod_gateway" {
  repository = "https://angelnu.github.io/helm-charts"
  name       = "pod-gateway"
  chart      = "pod-gateway"
  namespace  = var.namespace
  #  create_namespace = true
  #  namespace = "vpn-gateway" # error: MountVolume.SetUp failed for volume "gateway-configmap" : configmap "pod-gateway" not found in target namespace
  version = "6.5.1"

  values = [yamlencode(local.pod_gateway_values)]
}
