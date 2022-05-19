variable "config" {
  type = object({
    purpose = string
    meta    = object({
      platform = string
      language = string
    }) 
  })
}

output "input_config" {
  value = var.config
}

output "output_meta" {
  value = {
    for k,v in var.config.meta :
      "${var.config.purpose}-${k}" => v
  }
}