locals {
  kong_config = {
    "image": {
      "repository": "kong",
      "tag": "3.0"
    },
    "env": {
      "prefix": "/kong_prefix/",
      "database": "off"
    },
    "ingressController": {
      "enabled": true
    }
  }
}
