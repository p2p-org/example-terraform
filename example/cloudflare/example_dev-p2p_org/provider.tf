terraform {
  cloud {
    hostname     = "tap-api.infra.p2p.org"
    organization = "example"

    workspaces {
      name = "example-terraform"
    }
  }
  required_version = ">= 1.10.5, < 2"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 5.4.0, < 6"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.12.0, < 6"
    }
  }
}

provider "vault" {
  skip_child_token = true
}

ephemeral "vault_kv_secret_v2" "cloudflare_zone_creds" {
  mount    = "iaas/kv/default"
  name     = "terrakube/example/cloudflare-example_dev-p2p_org"
  mount_id = "1"
}

provider "cloudflare" {
  api_token = tostring(ephemeral.vault_kv_secret_v2.cloudflare_zone_creds.data.key)
}

data "cloudflare_zone" "example_dev-p2p_org" {
  zone_id = "4244bead163c3a48dba41b3f36f214db" # example.dev-p2p.org
}

output "cloudlfare_zone_info" {
  description = "Test cloudflare connection"
  value       = data.cloudflare_zone.example_dev-p2p_org.name
}