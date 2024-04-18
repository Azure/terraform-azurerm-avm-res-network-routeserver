variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the this route server resource."

  validation {
    condition     = can(regex("^[-_a-z0-9]{1,80}$", var.name))
    error_message = "The name must be between 1 and 80 characters long with letters, numbers, dashes, or underscores."
  }
}

# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
  nullable    = false
}

variable "resource_group_resource_id" {
  type        = string
  description = "The Azure Resource ID for the resource group where the resources will be deployed."
  nullable    = false
}

variable "route_server_subnet_resource_id" {
  type        = string
  description = "The Azure resource ID for the route server subnet where this route server resource will be deployed."
  nullable    = false
}

variable "bgp_connections" {
  type = map(object({
    name     = string
    peer_asn = string
    peer_ip  = string
  }))
  default     = {}
  description = "A map of bgp connections to make on each route server."
  nullable = false
}

variable "enable_branch_to_branch" {
  type        = bool
  default     = false
  description = "Should the branch to branch feature be enabled. Defaults to false."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "hub_routing_preference" {
  type        = string
  default     = "ExpressRoute"
  description = "The routing preference for this route server.  Valid values are `ASPath`, `ExpressRoute`, or `VpnGateway`. Defaults to `ExpressRoute`"
}

variable "lock" {
  type = object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
  default     = {}
  description = "The lock level to apply to the Route Server Virtual Hub. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`."
  nullable    = false

  validation {
    condition     = contains(["CanNotDelete", "ReadOnly", "None"], var.lock.kind)
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "private_ip_allocation_method" {
  type        = string
  description = "The private IP Address allocation method for this route server. Valid values are `Static` or `Dynamic`. Defaults to `Dynamic`."
  default     = "Dynamic"
}

variable "private_ip_address" {
  type        = string
  default     = null
  description = "The private ip address to use for the route server IP_configuration if the `private_ip_allocation_method` is set to `Static`."
}

# tflint-ignore: terraform_unused_declarations
variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
}

variable "routeserver_public_ip_name" {
  type        = string
  default     = null
  description = "The name for the public ip address resource associated with the route server."
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(any)
  default     = {}
  description = "The map of tags to be applied to the resource"
  nullable = false
}