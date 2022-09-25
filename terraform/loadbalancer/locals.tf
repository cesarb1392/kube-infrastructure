locals {
  metalb_config = {
    config = {
      address-pools = [
        {
          name : "cluster-pool"
          protocol : "layer2"
          addresses : [var.address_range]
        }
      ]
    }
  }
}
