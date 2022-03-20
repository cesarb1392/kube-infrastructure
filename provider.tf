terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
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
