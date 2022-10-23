locals {
  applications = {
    nginx = {
      enabled        = true
      cf_access      = true
      public_ingress = true
      image          = "nginx"
      target_service = "nginx-svc"
      ingress_port   = 80
    }
    portfolio = {
      enabled        = true
      public_ingress = true
      image          = "monkeybanana13/portfolio"
      target_service = "portfolio-svc"
      ingress_port   = 80
    }
    minio = {
      enabled        = true
      public_ingress = true
      cf_access      = false
      target_service = "minio"
      ingress_port   = 9000
    }
    wireguard = {
      enabled   = true
      log_level = "debug"
    }

    privateingress = {
      enabled = false
    }
    pihole = {
      enabled   = true
      log_level = "debug"
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
    for k, v in local.applications : k => v if try(v.public_ingress, null) != null && v.enabled
  }

  available_websites = {
    for k, v in local.applications : k => v if try(v.image, null) != null && v.enabled
  }

}
