locals {
  applications = {
    nginx = {
      enabled        = false
      image          = "nginx:latest"
      target_service = "nginx-svc"
      hostname       = "nginx"
      ingress_port   = 80
    }

    portfolio = {
      enabled        = true
      image          = "monkeybanana13/portfolio"
      target_service = "portfolio-svc"
      ingress_port   = 80
      hostname       = "portfolio"
    }
  }

  available_namespaces = {
    for k, v in local.applications : k => k if(v.enabled == true)
  }

  available_websites = {
    for k, v in local.applications : k => v if(v.enabled == true)
  }

}
