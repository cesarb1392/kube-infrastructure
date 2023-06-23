terraform {
  required_version = "> 1.4.0, < 2.0.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.24.0"
    }
  }

}
