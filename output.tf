# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

output "iam" {
  description = "The iam resource objects that define the access to the resources."
  value       = { for key, iam in module.iam : key => iam.iam }
}

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "secret" {
  description = "All `google_secret_manager_secret` resource attributes."
  value       = one(google_secret_manager_secret.secret)
}

output "policy_binding" {
  description = "All attributes of the created policy_bindings mineiros-io/secret-manager-iam/google module when using policy bindings."
  value       = module.policy_bindings
}
