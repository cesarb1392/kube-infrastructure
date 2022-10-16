resource "random_id" "this" {
  byte_length = 32
}

resource "cloudflare_argo_tunnel" "this" {
  account_id = var.CF_ACCOUNT_ID
  name       = "tunnel-${var.namespace}"
  secret     = random_id.this.b64_std
}

resource "cloudflare_record" "this" {
  zone_id = var.CF_ZONE_ID
  name    = var.hostname
  value   = cloudflare_argo_tunnel.this.cname
  type    = "CNAME"
  proxied = true
}
