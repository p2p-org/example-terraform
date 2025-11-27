locals {
  txt_records = {
    "test"    = ["test value"]
  }
  txt_records_expanded = flatten([
    for name, values in local.txt_records : [
      for content in values : {
        name    = name
        content = content
      }
    ]
  ])
}

resource "cloudflare_dns_record" "TXT_records" {
  for_each = {
    for i, value in local.txt_records_expanded:
    "${value.name}/${value.content}" => value
  }
  zone_id = data.cloudflare_zone.example_dev-p2p_org.zone_id
  ttl     = 1  # (Cloudflare `Auto` TTL)
  type    = "TXT"
  name    = each.value.name
  content = "\"${each.value.content}\""
  proxied = false
  comment = "IaC: https://github.com/p2p-org/example-terraform/tree/main/example/cloudflare/example_dev-p2p_org"
  tags    = ["iac", "example-terraform"]
}
