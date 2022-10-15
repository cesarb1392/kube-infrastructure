locals {
  metalb_config = {
    #    https://github.com/metallb/metallb/blob/main/charts/metallb/values.yaml
    speaker = {
      logLevel = "debug" # `debug`, `info`, `warn`, `error` or `none`
    }
  }

  default_address_pool = "192.168.178.3-192.168.178.9"
}
