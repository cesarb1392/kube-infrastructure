##https://danuka-praneeth.medium.com/how-i-configured-kong-plugins-2134887bb2cb
#
#data "cloudflare_ip_ranges" "cloudflare" {}
#
#resource "kubernetes_manifest" "cloudflare_ips" {
#  manifest = {
#    apiVersion = "configuration.konghq.com/v1"
#    kind       = "KongClusterPlugin"
#    metadata = {
#      name = "cloudflare-ips"
#      labels = {
#        global = true
#      }
#      annotations = {
#        "kubernetes.io/ingress.class" = "kong"
#      }
#    }
#
#    config = {
#      #      allow = tolist(data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks)
#      allow = [
#        "103.21.244.0/22",
#        "103.22.200.0/22",
#        "103.31.4.0/22",
#        "104.16.0.0/13",
#        "104.24.0.0/14",
#        "108.162.192.0/18",
#        "131.0.72.0/22",
#        "141.101.64.0/18",
#        "162.158.0.0/15",
#        "172.64.0.0/13",
#        "173.245.48.0/20",
#        "188.114.96.0/20",
#        "190.93.240.0/20",
#        "197.234.240.0/22",
#        "198.41.128.0/17",
#      ]
#    }
#    plugin = "ip-restriction"
#  }
#}
#
#
#resource "kubernetes_manifest" "bot_detection" {
#  manifest = {
#    apiVersion = "configuration.konghq.com/v1"
#    kind       = "KongClusterPlugin"
#    metadata = {
#      name = "bot-detect"
#      labels = {
#        global = true
#      }
#      annotations = {
#        "kubernetes.io/ingress.class" = "kong"
#      }
#    }
#    plugin = "bot-detection"
#  }
#}
#
#resource "kubernetes_manifest" "rate_limit" {
#  manifest = {
#    apiVersion = "configuration.konghq.com/v1"
#    kind       = "KongClusterPlugin"
#    metadata = {
#      name = "rate-limit"
#      labels = {
#        global = true
#      }
#      annotations = {
#        "kubernetes.io/ingress.class" = "kong"
#      }
#    }
#
#    config = {
#      minute   = 10
#      policy   = "local"
#      limit_by = "ip"
#    }
#
#    plugin = "rate-limiting"
#  }
#}
#
##resource "kubernetes_manifest" "basic_auth" {
##  manifest = {
##    apiVersion = "configuration.konghq.com/v1"
##    kind       = "KongClusterPlugin"
##    metadata   = {
##      name   = "basic-auth"
##      labels = {
##        global = true
##      }
##      annotations = {
##        "kubernetes.io/ingress.class" = "kong"
##      }
##    }
##    config = {
##      hide_credentials = true
##    }
##    plugin = "basic-auth"
##  }
##}
