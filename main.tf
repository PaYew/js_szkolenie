resource "digitalocean_project" "this" {
  name        = var.name
  description = "An example DigitalOcean project"
  purpose     = "Web Application"
  environment = "Development"
  resources = [digitalocean_droplet.this.urn]
}

resource "digitalocean_vpc" "this" {
  name     = var.name
  region   = var.region
  ip_range = var.subnet
}

resource "digitalocean_droplet" "this" {
  name     = var.name
  region   = var.region
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-24-04-x64"
  vpc_uuid = digitalocean_vpc.this.id
  ssh_keys = [digitalocean_ssh_key.this.id]
}

resource "digitalocean_ssh_key" "this" {
  name       = var.name
  public_key = tls_private_key.this.public_key_openssh
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "digitalocean_firewall" "this" {
  name        = var.name
  droplet_ids = [digitalocean_droplet.this.id]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["83.11.19.165/32"]
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

resource "local_file" "this" {
  filename = "${path.root}/id_ed25519"
  file_permission = "0600"
  content = tls_private_key.this.private_key_openssh
}
