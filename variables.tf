# W pliku variables.tf znajduje się deklaracja zmiennej do_token, która przechowuje klucz API do DigitalOcean.

variable "do_token" {
  description = "DigitalOcean API key - please generate one at https://cloud.digitalocean.com/account/api/tokens"
  sensitive   = true
}

# Dodatkowe zienne, które są wykorzystywane w pliku main.tf
variable "default_region" {
  description = "DigitalOcean region where the resouces will be created"
  default     = "fra1"
}

variable "default_name" {
  description = "Default name for the resources"
  default     = "default"
}

variable "ip_range" {
  description = "IP range for the VPC"
  default     = "10.30.30.0/24"
}
