locals {
  metalb_config = {
    configInline = {
      address-pools = [
        {
          name : "config"
          protocol : "layer2"
          addresses : [var.address_range]
        }
      ]
    }
  }
}
