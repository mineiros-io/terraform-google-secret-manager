locals {
  # filter all objects that define a single role
  iam_role = [for iam in var.iam : iam if can(iam.role)]

  # filter all objects that define multiple roles and expand them to single roles
  iam_roles = flatten([for iam in var.iam :
    [for role in iam.roles : merge(iam, { role = role })] if can(iam.roles)
  ])

  iam = concat(local.iam_role, local.iam_roles)

  iam_map = { for idx, iam in local.iam :
    try(iam._key, iam.role) => iam
  }
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-secret-manager-iam?ref=v0.2.0"

  for_each = [local.iam_map, {}][var.policy_bindings == null ? 0 : 1]

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  secret_id = try(google_secret_manager_secret.secret[0].secret_id, null)

  role                 = each.value.role
  members              = try(each.value.members, [])
  computed_members_map = var.computed_members_map
  authoritative        = try(each.value.authoritative, true)
}

module "policy_bindings" {
  source = "github.com/mineiros-io/terraform-google-secret-manager-iam?ref=v0.2.0"

  count = var.policy_bindings != null ? 1 : 0

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  secret_id            = try(google_secret_manager_secret.secret[0].secret_id, null)
  policy_bindings      = var.policy_bindings
  computed_members_map = var.computed_members_map
}
