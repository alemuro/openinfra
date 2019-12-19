provider "cloudflare" {
  email   = "${var.cloudflare_email}"
  api_key = "${var.cloudflare_token}"
}

data "cloudflare_zones" "zone_id" {
  filter {
    name   = "${var.domain}"
    status = "active"
    paused = false
  }
}

resource "cloudflare_record" "domain" {
  zone_id = "${lookup(data.cloudflare_zones.zone_id.zones[0],"id")}"
  name    = "${var.project}"
  value   = "${aws_eip.public_ip.public_ip}"
  type    = "A"
  ttl     = 1
  proxied = true
}
