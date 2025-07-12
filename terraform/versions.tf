terraform {
  required_version = "> 1.5.0, < 2.0.0"

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
    curl = {
      source  = "anschoewe/curl"
      version = ">= 1.0.2"
    }
  }
}

# terraform {
#   backend "s3" {
#     bucket                      = "kube-infrastructure"
#     key                         = "terraform.tfstate"
#     endpoint                    = "https://minio.cesarb.dev"
#     region                      = "main"
#     skip_credentials_validation = true
#     skip_metadata_api_check     = true
#     skip_region_validation      = true
#     force_path_style            = true
#   }
# }

provider "kubernetes" {
  config_path = var.KUBECONFIG
}

provider "kubectl" {
  config_path = var.KUBECONFIG
}

provider "helm" {
  kubernetes {
    config_path = var.KUBECONFIG
  }
  debug = true
}

provider "cloudflare" {
  api_token = var.CF_API_TOKEN
}

