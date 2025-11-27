terraform {
  cloud {
    hostname     = "tap-api.infra.p2p.org"
    organization = "example"

    workspaces {
      name = "cloudflare-example_dev-p2p_org"
    }
  }
  required_version = ">= 1.10.5, < 2"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.12.0, < 6"
    }
  }
}


variable "cloudflare_api_token" {
  type    = string
  default = ""
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_zone" "example_dev-p2p_org" {
  zone_id = "4244bead163c3a48dba41b3f36f214db" # example.dev-p2p.org
}

output "cloudlfare_key" {
  description = "Reveal Cloudflare Key"
  value       = nonsensitive(var.cloudflare_api_token)
  sensitive   = false
}