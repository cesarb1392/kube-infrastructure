locals {
  ports = {
    jackett      = 9117
    transmission = 9091
  }
  hosts = {
    jackett      = "Host(`jackett.192.168.2.20.nip.io`)"
    transmission = "Host(`transmission.192.168.2.20.nip.io`)"
  }
}
