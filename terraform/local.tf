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
      image          = "monkeybanana13/portfolio"
      target_service = "portfolio-svc"
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
      enabled = false
    }

    privateingress = {
      enabled = false
    }
    pihole = {
      enabled = false
    }
    metallb = {
      enabled   = false
      log_level = "debug"
    }

    monitoring = {
      enabled = false

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
