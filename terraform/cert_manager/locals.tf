locals {
  #  https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml
  cert_manager_config = {
    installCRDs = true
  }
}
