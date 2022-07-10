terraform {
  required_version = ">= 1.0.2"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.7"
    }
    pihole = {
      source  = "ryanwholey/pihole"
      version = ">= 0.0.12"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.k3s_config)
}

provider "kubectl" {
  config_path = pathexpand(var.k3s_config)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.k3s_config)
  }
}

provider "cloudflare" {
  email     = var.CF_EMAIL
  api_token = var.CF_API_TOKEN
}
