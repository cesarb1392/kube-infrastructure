#
#resource "cloudflare_access_application" "this" {
#  zone_id          = local.cloudflared.zone_id
#  name             = local.atlantis.name
#  domain           = format("%s.%s", local.atlantis.name, local.atlantis.domain)
#  session_duration = "24h"
#}
#
#resource "cloudflare_access_policy" "github" {
#  application_id = cloudflare_access_application.this.id
#  zone_id        = local.cloudflared.zone_id
#  name           = "GitHub webhook bypass"
#  precedence     = "1"
#  decision       = "bypass"
#  include {
#    ip = local.cloudflared.ip_bypass
#  }
#}
#
#resource "cloudflare_access_policy" "users" {
#  application_id = cloudflare_access_application.this.id
#  zone_id        = local.cloudflared.zone_id
#  name           = "VanMoof Employees"
#  precedence     = "2"
#  decision       = "allow"
#  include {
#    email_domain = ["vanmoof.com"]
#  }
#}
