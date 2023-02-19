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
  precedence     = 1
  include {
    email = var.CF_ACCESS_EMAIL_LIST
    #    group = [cloudflare_access_group.this.0.id]
  }
}

#resource "cloudflare_access_group" "this" {
#  count = var.cf_access ? 1 : 0
#
#  account_id = var.CF_ACCOUNT_ID
#  name       = "Banana users"
#  include {
#    email_domain = ["cesarb.dev"]# [trim(var.CF_ACCESS_EMAIL_LIST.0, "contact")]
#  }
#}
#resource "cloudflare_access_identity_provider" "okta" {
#  account_id = var.account_id
#  name       = "Banana users"
#  type       = "google-apps"
#}