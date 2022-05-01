resource "cloudflare_record" "cesarb_dev_A_cesarb_dev" {
  zone_id = local.cloudflare_zone_id
  name    = "cesarb.dev"
  type    = "A"
  value   = "84.85.77.49"
  proxied = true
  ttl     = local.default_ttl
}
resource "cloudflare_record" "cesarb_dev_A_nginx" {
  zone_id = local.cloudflare_zone_id
  name    = "nginx"
  type    = "A"
  value   = "84.85.77.49"
  proxied = true
  ttl     = local.default_ttl
}
resource "cloudflare_record" "cesarb_dev_A_traefik" {
  zone_id = local.cloudflare_zone_id
  name    = "traefik"
  type    = "A"
  value   = "84.85.77.49"
  proxied = true
  ttl     = local.default_ttl

}

resource "cloudflare_record" "cesarb_dev_CNAME_fm1__domainkey" {
  zone_id = local.cloudflare_zone_id
  name    = "fm1._domainkey"
  type    = "CNAME"
  value   = "fm1.cesarb.dev.dkim.fmhosted.com"
  proxied = true
  ttl     = local.default_ttl

}
resource "cloudflare_record" "cesarb_dev_CNAME_fm2__domainkey" {
  zone_id = local.cloudflare_zone_id
  name    = "fm2._domainkey"
  type    = "CNAME"
  value   = "fm2.cesarb.dev.dkim.fmhosted.com"
  proxied = true
  ttl     = local.default_ttl

}
resource "cloudflare_record" "cesarb_dev_CNAME_fm3__domainkey" {
  zone_id = local.cloudflare_zone_id
  name    = "fm3._domainkey"
  type    = "CNAME"
  value   = "fm3.cesarb.dev.dkim.fmhosted.com"
  proxied = true
  ttl     = local.default_ttl

}
resource "cloudflare_record" "cesarb_dev_CNAME_www" {
  zone_id = local.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"
  value   = "cesarb.dev"
  proxied = true
  ttl     = local.default_ttl

}
resource "cloudflare_record" "cesarb_dev_MX_1" {
  zone_id  = local.cloudflare_zone_id
  name     = "*"
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  proxied  = false
  ttl      = local.default_ttl
  priority = 10
}
resource "cloudflare_record" "cesarb_dev_MX_2" {
  zone_id  = local.cloudflare_zone_id
  name     = "*"
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  proxied  = false
  ttl      = local.default_ttl
  priority = 20
}
resource "cloudflare_record" "cesarb_dev_MX_cesarb_dev_1" {
  zone_id  = local.cloudflare_zone_id
  name     = "cesarb.dev"
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  proxied  = false
  ttl      = local.default_ttl
  priority = 20
}
resource "cloudflare_record" "cesarb_dev_MX_cesarb_dev_2" {
  zone_id  = local.cloudflare_zone_id
  name     = "cesarb.dev"
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  proxied  = false
  ttl      = local.default_ttl
  priority = 10
}
resource "cloudflare_record" "cesarb_dev_TXT_cesarb_dev" {
  zone_id = local.cloudflare_zone_id
  name    = "cesarb.dev"
  type    = "TXT"
  value   = "v=spf1 include:spf.messagingengine.com ?all"
  proxied = false
  ttl     = local.default_ttl

}
