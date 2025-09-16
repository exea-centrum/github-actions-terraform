# main.tf jest naszym glownym plikiem konfiguracyjnym, w ktorym definiujemy zasoby, ktore chcemy utworzyc w DigitalOcean.

# Maszyna Wirtualna - w digitalocean maszyna wirtualna zawsze ma przypisany publiczny adres IP
resource "digitalocean_droplet" "wirtual_machne" {
  image    = "ubuntu-22-04-x64"
  name     = "${var.default_name}-${random_string.name.result}-droplet"
  region   = var.default_region
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.form_file.id, digitalocean_ssh_key.generated.id]
  vpc_uuid = digitalocean_vpc.network.id
}

# Random String
# Wykorzystamy to w celu zagwarantowania unikatowych nazw dla zsobów
resource "random_string" "name" {
  length      = 6
  special     = false
  numeric     = true
  lower       = true
  min_lower   = 3
  min_numeric = 3
}

# Network VPC
resource "digitalocean_vpc" "network" {
  name        = "${var.default_name}-${random_string.name.result}-vpc"
  region      = var.default_region
  ip_range    = var.ip_range
  description = "VPC for the resources"
}

# Firewall Security Group
resource "digitalocean_firewall" "main" {
  name        = "${var.default_name}-${random_string.name.result}-firewall"
  droplet_ids = [digitalocean_droplet.wirtual_machne.id]

  # Reguły dla Firewall / Security Group - ruch przychodzący
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  # Reguły dla Firewall / Security Group - ruch wychodzący
  # trzeba zdefiniowa osobno dla tcp, udp i icmp (opcjonalnie)
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }
}

# SSH Klucz dostarczany z pliku
# W digitalocean mamy serwis do przechowywania kluczy SSH, które moemy pozniej wykorzystac przy tworzeniu maszyn wirtualnych
resource "digitalocean_ssh_key" "form_file" {
  name       = "${var.default_name}-${random_string.name.result}-form_file"
  public_key = file("./_files/public_ssh_keys/key.pub")
}

# SSH Klucz generowany przez Terraform
resource "tls_private_key" "generated" {
  algorithm = "ED25519"
}

# SSH Klucz generowany przez Terraform
resource "digitalocean_ssh_key" "generated" {
  name       = "${var.default_name}-${random_string.name.result}-generated"
  public_key = tls_private_key.generated.public_key_openssh
}
