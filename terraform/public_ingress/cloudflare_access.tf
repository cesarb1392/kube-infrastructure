resource "cloudflare_access_application" "this" {
  count = var.cf_access ? 1 : 0

  zone_id          = var.CF_ZONE_ID
  name             = var.hostname
  domain           = "${var.hostname}.${var.CF_ZONE_NAME}"
  session_duration = "24h"
}

resource "cloudflare_access_policy" "this" {
  count = var.cf_access ? 1 : 0

  application_id = cloudflare_access_application.this.0.id
  zone_id        = var.CF_ZONE_ID
  name           = "Banana Access"
  decision       = "allow"
  include {
    email = ["contact@cesarb.dev"]
  }
  precedence = 1
}
