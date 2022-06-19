terraform {
  required_version = ">= 1.0.2"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.7"
    }
    pihole = {
      source = "ryanwholey/pihole"
      version = ">= 0.0.12"
    }
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.k3s_config)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.k3s_config)
  }
}

provider "cloudflare" {
  account_id = var.K3S_CF_ACCOUNT_ID
  email      = var.K3S_CF_EMAIL
  api_key    = var.K3S_CF_API_KEY
}
