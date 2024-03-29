# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "secret_id" {
  description = "(Required) The resource name of the folder the policy is attached to. Its format is folders/{folder_id}."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "replicas" {
  description = "(Optional) A list of replicas for the secret will be replicated in according to the location set in the location property. If empty The Secret will automatically be replicated without any restrictions."
  type        = any
  default     = []

  validation {
    condition     = alltrue([for x in var.replicas : can(x.location)])
    error_message = "Location property must be set for every replica."
  }
}

variable "labels" {
  type        = map(string)
  description = "(Optional) The labels assigned to this Secret. Label keys must be between 1 and 63 characters long, have a UTF-8 encoding of maximum 128 bytes, and must conform to the following PCRE regular expression: '[\\p{Ll}\\p{Lo}][\\p{Ll}\\p{Lo}\\p{N}-]{0,62}' Label values must be between 0 and 63 characters long, have a UTF-8 encoding of maximum 128 bytes, and must conform to the following PCRE regular expression: [\\p{Ll}\\p{Lo}\\p{N}-]{0,63} No more than 64 labels can be assigned to a given resource. An object containing a list of 'key': value pairs."
  default     = {}
}

variable "expire_time" {
  description = "(Optional) Timestamp in UTC when the Secret is scheduled to expire. This is always provided on output, regardless of what was sent on input. A timestamp in RFC3339 UTC 'Zulu' format, with nanosecond resolution and up to nine fractional digits. Examples: '2014-10-02T15:01:23Z' and '2014-10-02T15:01:23.045123456Z'."
  type        = string
  default     = null
}

variable "ttl" {
  description = "(Optional) The TTL for the Secret. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: '3.5s'."
  type        = string
  default     = null
}

variable "topics" {
  description = "(Optional) A list of up to 10 Pub/Sub topics to which messages are published when control plane operations are called on the secret or its versions. Structure is documented below. If you set topics, you will need to set rotation too."
  type        = set(string)
  default     = null

  validation {
    condition     = var.topics == null ? true : length(var.topics) <= 10
    error_message = "A list of up to 10 Pub/Sub topics."
  }
}

variable "rotation" {
  description = "(Optional) The rotation time and period for a Secret. At `next_rotation_time`, Secret Manager will send a Pub/Sub notification to the topics configured on the Secret. topics must be set to configure rotation."
  type        = any
  default     = null
}

variable "project" {
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = null
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
}

variable "computed_members_map" {
  type        = map(string)
  description = "(Optional) A map of members to replace in 'members' to handle terraform computed values. Will be ignored when policy bindings are used."
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.computed_members_map : can(regex("^(allUsers|allAuthenticatedUsers|(user|serviceAccount|group|domain|projectOwner|projectEditor|projectViewer):)", v))])
    error_message = "The value must be a non-empty list of strings where each entry is a valid principal type identified with `user:`, `serviceAccount:`, `group:`, `domain:`, `projectOwner:`, `projectEditor:` or `projectViewer:`."
  }
}


# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
