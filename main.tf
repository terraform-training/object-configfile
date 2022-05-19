variable "project" {
  type = string
}

## A simple type (map of strings)
variable "complex_map" {
  type = map(string)
}

## An object (collection of fields with possibly different values)
variable "complex_object" {
  type = object({
    purpose = string
    author  = string
    licence = string
    meta    = object({
      language = string
      platform = string
    })
  })
}

output "map" {
  value = var.complex_map
}

output "object" {
  value = var.complex_object
}

output "map_value" {
  value = "var.complex_map.purpose = ${var.complex_map.purpose}"
}

output "object_value" {
  value = "var.complex_object.purpose = ${var.complex_object.purpose}"
}

# output "object_non_existent_value" {
#   value = var.complex_object.effort # Not possible - This object does not have an attribute named "effort"
# }

output "object_subfield_value" {
  value = "var.complex_object.meta.language = ${var.complex_object.meta.language}"
}

## An object (collection of fields with possibly different values) created from a YAML file
locals {
  config_object = yamldecode(file("./config.yml"))
}

output "yaml_object" {
  value = local.config_object
}

output "yaml_object_subfield" {
  value = local.config_object.meta.language 
}

module "internal_module" {
  source = "./internal"
  config = local.config_object
}

output "module_input" {
  value = module.internal_module.input_config
}
output "module_output" {
  value = module.internal_module.output_meta
}

module "network" {
  source     = "./network"
  # for_each   = toset(local.config_object.networks)  # this is wrong,
  # "for_each" supports maps and sets of strings, but you have provided a set containing type object.

  for_each = { for network in local.config_object.networks : network.name => network } # this is ok. we construct the map.
  net_config = each.value
}

output "networks" {
  value = [
    for net in module.network : net.cidr
  ]
}