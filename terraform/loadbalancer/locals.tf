locals {
  metalb_config = {
    #    https://github.com/metallb/metallb/blob/main/charts/metallb/values.yaml
    speaker = {
      logLevel = "warn" # `all`, `debug`, `info`, `warn`, `error` or `none`
    }
  }

  default_address_pool = "192.168.178.230-192.168.178.235"
}
