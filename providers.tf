# W pliku providers.tf znajduje się konfiguracja dostawcy (provider) digitalocean.

provider "digitalocean" {
  # Poszczególne parametry definiowane są w dokumentacji dostawcy
  token = var.do_token
}
