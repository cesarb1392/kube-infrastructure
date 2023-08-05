terraform {
  backend "s3" {
    bucket                      = "k3s"
    key                         = "terraform.tfstate"
    endpoint                    = "https://minio.cesarb.dev"
    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

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

