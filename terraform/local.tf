locals {
  applications = {
    nginx = {
      enabled        = true
      cf_access      = true
      ingress        = true
      image          = "nginx"
      target_service = "nginx-svc"
      ingress_port   = 80
    }
    portfolio = {
      enabled        = true
      ingress        = true
      image          = "monkeybanana13/portfolio"
      target_service = "portfolio-svc"
      ingress_port   = 80
    }
    minio = {
      enabled        = true
      ingress        = true
      cf_access      = false
      target_service = "minio"
      ingress_port   = 9000
    }
    wireguard = {
      enabled        = false
      cf_access      = false
      ingress        = false
      target_service = "wireguard"
      ingress_port   = 51820
      log_level      = "debug"
    }

    privateingress = {
      enabled        = true
    }
    pihole = {
      enabled        = true
      target_service = "pihole"
      ingress_port   = 9090
      log_level      = "debug"
    }
    metallb = {
      enabled   = true
      log_level = "debug"
    }
  }

  available_namespaces = {
    for k, v in local.applications : k => k if v.enabled
  }

  available_ingresses = {
    for k, v in local.applications : k => v if try(v.ingress, null) != null && v.enabled
  }

  available_websites = {
    for k, v in local.applications : k => v if try(v.image, null) != null && v.enabled
  }

}
