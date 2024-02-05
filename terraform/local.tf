locals {
  applications = {
    cert-manager = {
      enabled = true
    }
    portfolio = {
      enabled        = true
      public_ingress = true # local.applications.portfolio.enabled
      runner         = false
      image          = "monkeybanana13/portfolio" # defining images creates default deployment
      target_service = "portfolio-svc"
      ingress_port   = 80
    }
    sharesecrets = {
      enabled        = false
      public_ingress = false # local.applications.shareasecret.enabled
      runner         = false
      image          = "monkeybanana13/share-a-secret"
      target_service = "sharesecrets-svc"
      ingress_port   = 80
    }
    minio = {
      enabled        = true
      public_ingress = true # local.applications.minio.enabled
      target_service = "minio"
      lan_ip         = "192.168.178.236"
      ingress_port   = 9000
      storage        = "500Mi"
    }
    wireguard = {
      enabled   = true
      log_level = "info"
      lan_ip    = "192.168.178.233"
      storage   = "1Gi"
    }
    privateingress = {
      enabled = false
    }
    pihole = {
      enabled = true
      lan_ip  = "192.168.178.232"
      #      storage = "512Mi" # pending!
    }

    ## seems like there should be a svc already created, otherwise it uses the default one and it fails cause
    ## it ain't attached to a pod
    metallb = {
      enabled      = true
      log_level    = "debug"
      address_pool = "192.168.178.230-192.168.178.240"
    }
    monitoring = {
      /* trying out https://github.com/carlosedp/cluster-monitoring */


      /* kubectl taint nodes mainbanana key1=value1:NoSchedule */
      /* kubectl taint nodes fastbanana key1=value1:NoSchedule- */
      enabled = true
      available = {
        carlosedp_monitoring = false
        grafana              = false
        graphite             = false
        promtail             = false
        loki                 = false
        prometheus_stack     = true ## arm64 doesn't work
        smokeping            = true
        wireshark            = true
      }
      lan_ip = "192.168.178.235"
    }
    loadtest = {
      enabled    = true
      target_url = "https://${var.CF_ZONE_NAME}"
    }
    vaultwarden = {
      enabled        = true
      cf_access      = false # otherwise the mobile app doesn't work
      public_ingress = true
      target_service = "vaultwarden-svc"
      ingress_port   = 80
      storage        = "3Gi"
      log_level      = "info"
    }
    githubrunner = {
      enabled     = false
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
    torrente = {
      enabled = false
      lan_ip  = "192.168.178.234"
      # storage = "1Gi"
    }
    picamera = {
      enabled        = false
      cf_access      = false
      public_ingress = false
      target_service = "picamera-svc"
      ingress_port   = 80
    }

  }

  available_namespaces = {
    for k, v in local.applications : k => k if v.enabled
  }

  public_ingress = {
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