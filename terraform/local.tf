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
      runner         = false
      image          = "monkeybanana13/portfolio" # defining images creates default deployment
      target_service = "portfolio-svc"
      ingress_port   = 80
    }
    sharesecrets = {
      enabled        = false
      public_ingress = false
      runner         = false
      image          = "monkeybanana13/share-a-secret"
      target_service = "sharesecrets-svc"
      ingress_port   = 80
    }
    minio = {
      enabled        = true
      public_ingress = true
      cf_access      = false
      target_service = "minio"
      ingress_port   = 9000
      storage        = "1Gi"
    }
    wireguard = {
      enabled  = true
      no_limit = true
      host_ip  = "192.168.178.233"
      storage  = "512Mi"
    }
    privateingress = {
      enabled = false
    }
    pihole = {
      enabled = false
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
      enabled    = false
      target_url = "https://${var.CF_ZONE_NAME}"
    }
    vaultwarden = {
      enabled        = true
      cf_access      = true
      public_ingress = true
      target_service = "vaultwarden-svc"
      ingress_port   = 80
      storage        = "1Gi"
    }
    githubrunner = {
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
    torrente = {
      enabled = true
      host_ip = "192.168.178.234"
      storage = "100Gi"
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

  available_storage = {
    for k, v in local.applications : k => v if try(v.storage, null) != null && v.enabled
  }

  limit_usage = {
    for k, v in local.applications : k => v if try(v.no_limit, null) == null && v.enabled
  }

}
