terraform {
  required_version = "> 1.4.0, < 2.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.8.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.24.0"
    }
  }
}
