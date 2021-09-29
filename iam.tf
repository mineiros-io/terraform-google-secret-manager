locals {
  iam_map = { for iam in var.iam : iam.role => iam }
}

module "iam" {
  source = "git@github.com:mineiros-io/terraform-google-secret-manager-iam?ref=v0.0.1"

  for_each = local.iam_map

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  secret_id     = google_secret_manager_secret.secret[0].secret_id
  role          = each.value.role
  members       = each.value.members
  authoritative = try(each.value.authoritative, true)
}
