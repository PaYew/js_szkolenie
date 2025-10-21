variable "do_token" {
  description = "Digitalocean api key"
  type        = string
  sensitive   = true
}

variable "subnet" {
  description = "Subnet for the droplet"
  type        = string
  default     = "10.11.12.0/24"
}

variable "name" {
  description = "Name"
  type        = string
  default     = "piotr-koska-resources-terraform"
}

variable "region" {
  description = "Name of region"
  type = string
  default = "fra1"
}
