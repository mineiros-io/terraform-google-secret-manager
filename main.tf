
resource "google_secret_manager_secret" "secret" {
  count = var.module_enabled ? 1 : 0

  depends_on = [var.module_depends_on]

  secret_id   = var.secret_id
  labels      = var.labels
  expire_time = var.expire_time
  ttl         = var.ttl
  project     = var.project

  dynamic "replication" {
    for_each = length(var.replicas) == 0 ? ["automatic"] : []

    content {
      automatic = true
    }
  }

  dynamic "replication" {
    for_each = length(var.replicas) > 0 ? ["user_managed"] : []

    content {
      user_managed {
        dynamic "replicas" {
          for_each = var.replicas

          content {
            location = replicas.value.location

            dynamic "customer_managed_encryption" {
              for_each = try(replicas.value.customer_managed_encryption, [])

              content {
                kms_key_name = customer_managed_encryption.value.kms_key_name
              }
            }
          }
        }
      }
    }
  }

  dynamic "topics" {
    for_each = var.topics != null ? var.topics : []

    content {
      name = topics.value
    }
  }

  dynamic "rotation" {
    for_each = var.rotation != null ? ["rotation"] : []

    content {
      next_rotation_time = try(var.rotation.next_rotation_time, null)
      rotation_period    = try(var.rotation.rotation_period, null)
    }
  }

}
