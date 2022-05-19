variable "net_config" {
  type = object({
    name = string
    cidr = string
  })
}

output "cidr" {
  value = var.net_config.cidr
}