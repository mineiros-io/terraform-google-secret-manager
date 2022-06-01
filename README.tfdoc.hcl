header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-secret-manager"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-secret-manager/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-secret-manager/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-secret-manager.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-secret-manager/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-secret-manager"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create a [Google Secret Manager](https://cloud.google.com/secret-manager) on [Google Cloud Services (GCP)](https://cloud.google.com/)

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following terraform resources:

      - `google_secret_manager_secret`

      and supports additional features of the following modules:

      - [mineiros-io/terraform-google-secret-manager-iam](https://github.com/mineiros-io/terraform-google-secret-manager-iam)
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-google-secret-manager" {
        source = "github.com/mineiros-io/terraform-google-secret-manager.git?ref=v0.1.4"

        secret_id = "secret"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "secret_id" {
        required    = true
        type        = string
        description = <<-END
          This must be unique within the project.
        END
      }

      variable "replicas" {
        type           = list(replica)
        default        = []
        description    = <<-END
          A list of replicas for the secret will be replicated in according to the location set in the location property. If empty The Secret will automatically be replicated without any restrictions.
        END
        readme_example = <<-END
          replicas = [{
            location = "us-central1"
          }]
        END

        attribute "location" {
          required    = true
          type        = string
          description = <<-END
            The canonical IDs of the location to replicate data. For example: `us-east1`.
          END
        }

        attribute "customer_managed_encryption" {
          type           = object(customer_managed_encryption)
          description    = <<-END
            Customer Managed Encryption for the secret.
          END
          readme_example = <<-END
            customer_managed_encryption = {
              kms_key_name = "mykey"
            }
          END

          attribute "kms_key_name" {
            required    = true
            type        = string
            description = <<-END
              Describes the Cloud KMS encryption key that will be used to protect destination secret.
            END
          }
        }
      }

      variable "labels" {
        type           = map(string)
        default        = {}
        description    = <<-END
          The labels assigned to this Secret. Label keys must be between 1 and 63 characters long, have a UTF-8 encoding of maximum 128 bytes, and must conform to the following PCRE regular expression: `[\p{Ll}\p{Lo}][\p{Ll}\p{Lo}\p{N}-]{0,62}` Label values must be between 0 and 63 characters long, have a UTF-8 encoding of maximum 128 bytes, and must conform to the following PCRE regular expression: `[\p{Ll}\p{Lo}\p{N}-]{0,63}` No more than 64 labels can be assigned to a given resource. An object containing a list of `key: value` pairs.
        END
        readme_example = <<-END
          labels = {
            "app": "web",
            "env": "prod"
          }
        END
      }

      variable "expire_time" {
        type        = string
        description = <<-END
          Timestamp in UTC when the Secret is scheduled to expire. This is always provided on output, regardless of what was sent on input. A timestamp in RFC3339 UTC `Zulu` format, with nanosecond resolution and up to nine fractional digits. Examples: `2014-10-02T15:01:23Z` and `2014-10-02T15:01:23.045123456Z`.
        END
      }

      variable "ttl" {
        type        = string
        description = <<-END
          The TTL for the Secret. A duration in seconds with up to nine fractional digits, terminated by `s`. Example: `3.5s`.
        END
      }

      variable "topics" {
        type        = set(string)
        description = <<-END
          A list of up to 10 Pub/Sub topics to which messages are published when control plane operations are called on the secret or its versions. Structure is documented below. If you set topics, you will need to set rotation too.
        END
      }

      variable "rotation" {
        type           = object(rotation)
        description    = <<-END
          The rotation time and period for a Secret. At `next_rotation_time`, Secret Manager will send a Pub/Sub notification to the topics configured on the Secret. `topics` must be set to configure rotation.
        END
        readme_example = <<-END
          rotation = {
            next_rotation_time = "2022-10-02T15:01:23.045123456Z"
            rotation_period    = "3600s"
          }
        END

        attribute "next_rotation_time" {
          type        = string
          description = <<-END
            Timestamp in UTC at which the Secret is scheduled to rotate. A timestamp in RFC3339 UTC `Zulu` format, with nanosecond resolution and up to nine fractional digits. Examples: `2014-10-02T15:01:23Z` and `2014-10-02T15:01:23.045123456Z`.
          END
        }

        attribute "rotation_period" {
          type        = string
          description = <<-END
            The Duration between rotation notifications. Must be in seconds and at least `3600s` (1h) and at most `3153600000s` (100 years). If rotationPeriod is set, `next_rotation_time` must be set. `next_rotation_time` will be advanced by this period when the service automatically sends rotation notifications.
          END
        }
      }

      variable "project" {
        type        = string
        description = <<-END
          The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
        END
      }
    }

    section {
      title = "Extended Resource Configuration"

      variable "iam" {
        type           = list(iam)
        default        = []
        description    = <<-END
          A list of IAM access.
        END
        readme_example = <<-END
          iam = [{
            role = "roles/secretmanager.admin"
            members = ["user:member@example.com"]
            authoritative = false
          }]
        END

        attribute "members" {
          type        = set(string)
          default     = []
          description = <<-END
            Identities that will be granted the privilege in role. Each entry can have one of the following values:
            - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
            - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
            - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@gmail.com or joe@example.com.
            - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
            - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
            - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.
            - `projectOwner:projectid`: Owners of the given project. For example, `projectOwner:my-example-project`
            - `projectEditor:projectid`: Editors of the given project. For example, `projectEditor:my-example-project`
            - `projectViewer:projectid`: Viewers of the given project. For example, `projectViewer:my-example-project`
          END
        }

        attribute "role" {
          type        = string
          description = <<-END
            The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
          END
        }

        attribute "authoritative" {
          type        = bool
          default     = true
          description = <<-END
            Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.
          END
        }
      }

      variable "policy_bindings" {
        type           = list(policy_bindings)
        description    = <<-END
          A list of IAM policy bindings.
        END
        readme_example = <<-END
          policy_bindings = [{
            role    = "roles/secretmanager.admin"
            members = ["user:member@example.com"]
            condition = {
              title       = "expires_after_2021_12_31"
              description = "Expiring at midnight of 2021-12-31"
              expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
            }
          }]
        END

        attribute "role" {
          required    = true
          type        = string
          description = <<-END
            The role that should be applied.
          END
        }

        attribute "members" {
          type        = set(string)
          default     = var.members
          description = <<-END
            Identities that will be granted the privilege in `role`.
          END
        }

        attribute "condition" {
          type           = object(condition)
          description    = <<-END
            An IAM Condition for a given binding.
          END
          readme_example = <<-END
            condition = {
              expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
              title      = "expires_after_2021_12_31"
            }
          END

          attribute "expression" {
            required    = true
            type        = string
            description = <<-END
              Textual representation of an expression in Common Expression Language syntax.
            END
          }

          attribute "title" {
            required    = true
            type        = string
            description = <<-END
              A title for the expression, i.e. a short string describing its purpose.
            END
          }

          attribute "description" {
            type        = string
            description = <<-END
              An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.
            END
          }
        }
      }
    }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        readme_example = <<-END
          module_depends_on = [
            google_network.network
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "module_enabled" {
      type        = bool
      description = <<-END
        Whether this module is enabled.
      END
    }

    output "secret" {
      type        = object(secret)
      description = <<-END
        All `google_secret_manager_secret` resource attributes.
      END
    }

    output "iam" {
      type        = list(iam)
      description = <<-END
        All attributes of the created policy_bindings mineiros-io/secret-manager-iam/google module when using iam bindings or members.
      END
    }

    output "policy_binding" {
      type        = list(iam)
      description = <<-END
        All attributes of the created policy_bindings mineiros-io/secret-manager-iam/google module when using policy bindings.
      END
    }

  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - Secret Manager: https://cloud.google.com/secret-manager
      END
    }

    section {
      title   = "Terraform Google Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-secret-manager"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/workflows/Tests/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-secret-manager.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "badge-tf-gcp" {
    value = "https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform"
  }
  ref "releases-google-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-google/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "gcp" {
    value = "https://cloud.google.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/CONTRIBUTING.md"
  }
}
