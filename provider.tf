terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.config_path)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.config_path)
  }
}
