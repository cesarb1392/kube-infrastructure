terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.4.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.1"
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
