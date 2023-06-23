locals {
  applications = {
    portfolio = {
      enabled        = true
      public_ingress = true
      runner         = true
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
      target_service = "minio"
      ingress_port   = 9000
      storage        = "500Mi"
    }
    wireguard = {
      enabled   = true
      log_level = "info"
      lan_ip    = "192.168.178.233"
      storage   = "512Mi"
    }
    privateingress = {
      enabled = false
    }
    pihole = {
      enabled = false
      lan_ip  = "192.168.178.232"
      storage = "512Mi"
    }
    metallb = {
      enabled      = true
      log_level    = "debug"
      address_pool = "192.168.178.230-192.168.178.240"
    }
    monitoring = {
      enabled = true
      available = {
        grafana    = false
        graphite   = false
        promtail   = false
        loki       = false
        prometheus = true
        smokeping  = false
        wireshark  = false
      }
      lan_ip = "192.168.178.235"
    }
    loadtest = {
      enabled    = false
      target_url = "https://${var.CF_ZONE_NAME}"
    }
    vaultwarden = {
      enabled        = true
      cf_access      = false # otherwise the mobile app doesn't work
      public_ingress = true
      target_service = "vaultwarden-svc"
      ingress_port   = 80
      storage        = "1Gi"
      log_level      = "info"
    }
    githubrunner = {
      enabled     = true
      runner_name = "bananaRunner"
      repos = {
        myawesomecv = {
          url = "https://github.com/cesarb1392/myAwesomeCV"
        },
        shareasecret = {
          url = "https://github.com/cesarb1392/shareAsecret"
        }
      }
    }
    torrenteold = {
      enabled = false
      lan_ip  = "192.168.178.234"
      storage = "25Gi"
    }
    torrente = {
      enabled = true
      lan_ip  = "192.168.178.234"
      storage = "30Gi"
    }
    picamera = {
      enabled        = false
      cf_access      = true
      public_ingress = true
      target_service = "picamera-svc"
      ingress_port   = 80
    }
  }

  available_namespaces = {
    for k, v in local.applications : k => k if v.enabled
  }

  available_ingresses = {
    for k, v in local.applications : k => v
    if try(v.public_ingress, null) != null && try(v.public_ingress, null) != false && v.enabled
  }

  available_websites = {
    for k, v in local.applications : k => v if try(v.image, null) != null && v.enabled
  }

  available_storage = {
    for k, v in local.applications : k => v if try(v.storage, null) != null && v.enabled
  }

}
