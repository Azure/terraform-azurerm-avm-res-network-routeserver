output "resource" {
  description = "This is the full output for the resource."
  #value       = jsondecode(azapi_resource.route_server_hub.output)
  value = data.azurerm_virtual_hub.this
}
