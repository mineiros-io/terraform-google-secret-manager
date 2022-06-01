locals {
  # filter all objects that define a single role
  iam_role = [for iam in var.iam : iam if can(iam.role)]

  # filter all objects that define multiple roles and expand them to single roles
  iam_roles = flatten([for iam in var.iam :
    [for role in iam.roles : merge(iam, { role = role })] if can(iam.roles)
  ])

  # we allow to define role and roles in the same object and concatenate them
  # each role can only be sepcified exactly once
  iam = concat(local.iam_role, local.iam_roles)

  iam_map = { for idx, iam in local.iam :
    try(iam._key, iam.role) => idx
  }
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-secret-manager-iam?ref=v0.0.4"

  for_each = var.policy_bindings == null ? local.iam_map : {}

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  secret_id = try(google_secret_manager_secret.secret[0].secret_id, null)
  role      = local.iam[each.value].role

  members = local.iam[each.value].members

  authoritative = try(local.iam[each.value].authoritative, true)
}

module "policy_bindings" {
  source = "github.com/mineiros-io/terraform-google-secret-manager-iam?ref=v0.0.4"

  count = var.policy_bindings != null ? 1 : 0

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  secret_id       = try(google_secret_manager_secret.secret[0].secret_id, null)
  policy_bindings = var.policy_bindings
}

variable "iam" {
  description = "(Optional) A list of IAM access roles and members."
  type        = any
  default     = []

  # validate that at least one required attribute of 'role' or 'roles' is defined in each iam object
  validation {
    condition     = alltrue([for x in var.iam : can(x.role) || can(x.roles)])
    error_message = "Each object in 'var.iam' must specify a single 'role' or a set of 'roles'."
  }

  # validate that members attribute is set in each object
  validation {
    condition     = alltrue([for x in var.iam : can(x.members)])
    error_message = "Each object in 'var.iam' must specify a set of 'members'."
  }

  # validate no invalid attributes are set in each object
  validation {
    condition     = alltrue([for x in var.iam : length(setsubtract(keys(x), ["role", "roles", "members", "authoritative"])) == 0])
    error_message = "Each object in 'var.iam' does only support the 'role', 'roles', 'members', and 'authoritative' attributes."
  }
}

variable "policy_bindings" {
  description = "(Optional) A list of IAM policy bindings."
  type        = any
  default     = null

  # validate required keys in each object
  validation {
    condition     = var.policy_bindings == null ? true : alltrue([for x in var.policy_bindings : can(x.role) && can(x.members)])
    error_message = "Each object in 'var.policy_bindings' must specify a 'role' and a set of 'members'."
  }

  # validate no invalid keys are in each object
  validation {
    condition     = var.policy_bindings == null ? true : alltrue([for x in var.policy_bindings : length(setsubtract(keys(x), ["role", "members", "condition"])) == 0])
    error_message = "Each object in 'var.policy_bindings' does only support 'role', 'members' and 'condition' attributes."
  }
}

output "iam" {
  description = "All attributes of the created policy_bindings mineiros-io/secret-manager-iam/google module when using iam bindings or members."
  value       = module.iam
}

output "policy_binding" {
  description = "All attributes of the created policy_bindings mineiros-io/secret-manager-iam/google module when using policy bindings."
  value       = module.policy_bindings
}
