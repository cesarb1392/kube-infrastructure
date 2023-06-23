locals {
  ports = {
    jackett = {
      internal = 9117
      external = 9091
    }
    transmission = {
      internal = 9091
      external = 9090
    }
  }
}
