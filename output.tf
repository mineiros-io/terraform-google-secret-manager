# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# remap iam to reduce one level of access (iam[]. instead of iam[].iam.)
output "iam" {
  description = "The iam resource objects that define the access to the secret."
  value       = { for key, iam in module.iam : key => iam.iam }
}

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "secret" {
  description = "All `google_secret_manager_secret` resource attributes."
  value       = try(google_secret_manager_secret.secret[0], null)
}

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}
