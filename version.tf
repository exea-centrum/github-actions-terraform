# W pliku terraform.tf znajduje się konfiguracja wersji terraform oraz wersji dostawcy (provider) digitalocean.

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.44.1"
    }
  }

  cloud {
    organization = "davtro"

    workspaces {
      name = "github-actions-terraform"
    }
  }

  required_version = ">= 1.9"
}
