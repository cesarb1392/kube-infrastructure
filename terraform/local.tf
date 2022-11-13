locals {
  applications = {
    nginx = {
      enabled        = false
      cf_access      = false
      public_ingress = false
      image          = "nginx"
      target_service = "nginx-svc"
      ingress_port   = 80
    }
    portfolio = {
      enabled        = true
      public_ingress = true
      runner         = true
      image          = "monkeybanana13/portfolio"
      target_service = "portfolio-svc"
      ingress_port   = 80
    }
    sharesecrets = {
      enabled        = true
      public_ingress = true
      runner         = true
      image          = "monkeybanana13/share-a-secret"
      target_service = "sharesecrets-svc"
      ingress_port   = 80
    }
    minio = {
      enabled        = false
      public_ingress = false
      cf_access      = false
      target_service = "minio"
      ingress_port   = 9000
    }
    wireguard = {
      enabled = true
      host_ip = "192.168.178.233"
    }

    privateingress = {
      enabled = false
    }
    pihole = {
      enabled = true
      host_ip = "192.168.178.232"
    }
    metallb = {
      enabled      = true
      log_level    = "debug"
      address_pool = "192.168.178.230-192.168.178.235"
    }

    monitoring = {
      enabled = false
    }

    loadtest = {
      enabled    = true
      target_url = "https://${var.CF_ZONE_NAME}"
    }

    github_runner = {
      enabled = true
      repos = {
        myawesomecv = {
          url = "https://github.com/cesarb1392/myAwesomeCV"
        },
        shareasecret = {
          url = "https://github.com/cesarb1392/shareAsecret"
        }
      }
    }
  }

  available_namespaces = {
    for k, v in local.applications : k => k if v.enabled
  }

  available_ingresses = {
    for k, v in local.applications : k => v if try(v.public_ingress, null) != null && v.enabled
  }

  available_websites = {
    for k, v in local.applications : k => v if try(v.image, null) != null && v.enabled
  }


}
