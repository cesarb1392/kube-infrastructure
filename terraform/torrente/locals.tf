locals {
  ports = {
    jackett = {
      internal = 9117
      external = 9091
    }
    transmission = {
      internal = 9091
      external = 9090
    }
  }

  vpn_pod_limits = {
    requests = {
      memory = "64Mi"
      cpu    = "250m"
    }
    limits = {
      memory = "128Mi"
      cpu    = "500m"
    }
  }

  server_country_selected = {
    for k, v in jsondecode(data.curl.get_servers_countries.response) : var.vpn_country_code => v.id
    if(v.code == var.vpn_country_code)
  }
  base_vpn_servers_uri = "https://api.nordvpn.com/v1/servers/recommendations?&filters[servers_technologies][identifier]=wireguard_udp&limit=1"
  vpn_servers_uri      = format("${local.base_vpn_servers_uri}%s", contains(keys(local.server_country_selected), var.vpn_country_code) ? "&filters[country_id]=${values(local.server_country_selected).0}" : "")
  vpc_server           = jsondecode(data.curl.get_vpn_servers.response)
}

data "curl" "get_servers_countries" {
  http_method = "GET"
  uri         = "https://api.nordvpn.com/v1/servers/countries"
}

data "curl" "get_vpn_servers" {
  http_method = "GET"
  uri         = local.vpn_servers_uri
}