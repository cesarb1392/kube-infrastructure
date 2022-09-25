terraform {
  required_version = ">= 1.0.2"

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
  }
}

provider "kubernetes" {
  config_path = "${path.cwd}/${var.k3s_config}"
}

provider "kubectl" {
  config_path = "${path.cwd}/${var.k3s_config}"
}

provider "helm" {
  kubernetes {
    config_path = "${path.cwd}/${var.k3s_config}"
  }
}
