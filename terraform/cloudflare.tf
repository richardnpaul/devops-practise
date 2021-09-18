resource "cloudflare_record" "site_cname" {
  zone_id = var.cloudflare_zone_id
  name    = var.site_domain
  value   = aws_s3_bucket.app_bucket.website_endpoint
  type    = "CNAME"

  ttl     = 1
  proxied = true
}

resource "cloudflare_page_rule" "https" {
  zone_id = var.cloudflare_zone_id
  target  = "*.${var.site_domain}/*"
  actions {
    always_use_https = true
  }
}