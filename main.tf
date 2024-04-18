resource "azapi_resource" "route_server_hub" {
  type      = "Microsoft.Network/virtualHubs@2023-04-01"
  name      = var.name
  location  = var.location
  parent_id = var.resource_group_resource_id
  body = jsonencode({
    properties = {
      sku                        = "Standard"
      hubRoutingPreference       = var.hub_routing_preference
      allowBranchToBranchTraffic = var.enable_branch_to_branch
    }
  })
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

resource "azurerm_public_ip" "route_server_pip" {
  allocation_method   = "Static"
  location            = var.location
  name                = local.routeserver_public_ip_name
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags
}

resource "azapi_resource" "route_server_ip_config_dynamic" {
  type      = "Microsoft.Network/virtualHubs/ipConfigurations@2023-04-01"
  name      = var.name
  #location  = var.location
  parent_id = azapi_resource.route_server_hub.id
  body = jsonencode({
    properties = {
      subnet = {
        id = var.route_server_subnet_resource_id
      }
      PublicIPAddress = {
        id = azurerm_public_ip.route_server_pip.id
      }
      privateIPAllocationMethod = var.private_ip_allocation_method
      privateIpAddress = (lower(var.private_ip_allocation_method) == "static" ? var.private_ip_address : null)
  }
})
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

resource "time_sleep" "wait_300_seconds" {
  depends_on = [ azapi_resource.route_server_ip_config_dynamic]

  create_duration = "300s"
}

#doing a forced read of the resource as the peer ips don't populate right away 
data "azurerm_virtual_hub" "this" {
    name = azapi_resource.route_server_hub.name
    resource_group_name = var.resource_group_name

    depends_on = [ time_sleep.wait_300_seconds ]
}

resource "azurerm_virtual_hub_bgp_connection" "this" {
  for_each = var.bgp_connections

  name           = each.value.name
  peer_asn       = each.value.peer_asn
  peer_ip        = each.value.peer_ip
  virtual_hub_id = azapi_resource.route_server_hub.id

  depends_on = [
    azapi_resource.route_server_ip_config_dynamic
  ]
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azapi_resource.route_server_hub.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check

  depends_on = [
    azapi_resource.route_server_ip_config_dynamic,
    azurerm_virtual_hub_bgp_connection.this
  ]
}

resource "azurerm_management_lock" "this" {
  count = var.lock.kind != "None" ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.name}")
  scope      = azapi_resource.route_server_hub.id

  depends_on = [ 
    azapi_resource.route_server_ip_config_dynamic,
    azurerm_virtual_hub_bgp_connection.this
   ]
}