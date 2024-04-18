<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-template

This is a template repo for Terraform Azure Verified Modules.

Things to do:

1. Set up a GitHub repo environment called `test`.
1. Configure environment protection rule to ensure that approval is required before deploying to this environment.
1. Create a user-assigned managed identity in your test subscription.
1. Create a role assignment for the managed identity on your test subscription, use the minimum required role.
1. Configure federated identity credentials on the user assigned managed identity. Use the GitHub environment.
1. Search and update TODOs within the code and remove the TODO comments once complete.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.6)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 1.9)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.99)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (~> 1.9)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.99)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azapi_update_resource.route_server_branch_to_branch](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/update_resource) (resource)
- [azapi_update_resource.route_server_hub_preferred_routing](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/update_resource) (resource)
- [azurerm_public_ip.route_server_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_resource_group_template_deployment.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_virtual_hub.route_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub) (resource)
- [azurerm_virtual_hub_bgp_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_bgp_connection) (resource)
- [azurerm_virtual_hub_ip.route_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_ip) (resource)
- [random_id.telem](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)
- [azurerm_virtual_hub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_hub) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the this route server resource.

Type: `string`

### <a name="input_private_ip_allocation_method"></a> [private\_ip\_allocation\_method](#input\_private\_ip\_allocation\_method)

Description: The private IP Address allocation method for this route server.  

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_route_server_subnet_resource_id"></a> [route\_server\_subnet\_resource\_id](#input\_route\_server\_subnet\_resource\_id)

Description: The Azure resource ID for the route server subnet where this route server resource will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_bgp_connections"></a> [bgp\_connections](#input\_bgp\_connections)

Description: A map of bgp connections to make on each route server.

Type:

```hcl
map(object({
    name     = string
    peer_asn = string
    peer_ip  = string
  }))
```

Default: `{}`

### <a name="input_enable_branch_to_branch"></a> [enable\_branch\_to\_branch](#input\_enable\_branch\_to\_branch)

Description: Should the branch to branch feature be enabled. Defaults to false.

Type: `bool`

Default: `false`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_hub_routing_preference"></a> [hub\_routing\_preference](#input\_hub\_routing\_preference)

Description: The routing preference for this route server.  Valid values are `ASPath`, `ExpressRoute`, or `VpnGateway`. Defaults to ExpressRoute

Type: `string`

Default: `"ExpressRoute"`

### <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address)

Description: The private ip address to use for the route server IP\_configuration if the `private_ip_allocation_method` is set to `Static`.

Type: `string`

Default: `null`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_routeserver_public_ip_name"></a> [routeserver\_public\_ip\_name](#input\_routeserver\_public\_ip\_name)

Description: The name for the public ip address resource associated with the route server.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: The map of tags to be applied to the resource

Type: `map(any)`

Default: `{}`

### <a name="input_virtual_hub_name"></a> [virtual\_hub\_name](#input\_virtual\_hub\_name)

Description: The name for the virtual hub resource for this route server.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_resource"></a> [resource](#output\_resource)

Description: This is the full output for the resource.

### <a name="output_route_server"></a> [route\_server](#output\_route\_server)

Description: n/a

### <a name="output_route_server_id"></a> [route\_server\_id](#output\_route\_server\_id)

Description: n/a

### <a name="output_virtual_hub"></a> [virtual\_hub](#output\_virtual\_hub)

Description: n/a

### <a name="output_virtual_hub_id"></a> [virtual\_hub\_id](#output\_virtual\_hub\_id)

Description: n/a

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->