[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Terraform Version][badge-terraform]][releases-terraform]
[![Google Provider Version][badge-tf-gcp]][releases-google-provider]
[![Join Slack][badge-slack]][slack]

# terraform-google-secret-manager

A [Terraform] module for [Google Cloud Platform (GCP)][gcp].

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource Configuration](#extended-resource-configuration)
      - [Google secret manager iam](#google-secret-manager-iam)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

In contrast to the plain `terraform_google_secret_manager_secret` resource this module has better features.
While all security features can be disabled as needed best practices
are pre-configured.

<!--
These are some of our custom features:

- **Default Security Settings**:
  secure by default by setting security to `true`, additional security can be added by setting some feature to `enabled`

- **Standard Module Features**:
  Cool Feature of the main resource, tags

- **Extended Module Features**:
  Awesome Extended Feature of an additional related resource,
  and another Cool Feature

- **Additional Features**:
  a Cool Feature that is not actually a resource but a cool set up from us

- _Features not yet implemented_:
  Standard Features missing,
  Extended Features planned,
  Additional Features planned
-->

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-secret-manager" {
  source = "github.com/mineiros-io/terraform-google-secret-manager.git?ref=v0.1.0"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: _(Optional `bool`)_

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_depends_on`**: _(Optional `list(dependencies)`)_

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:
  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- **`secret_id`**: **_(Required `string`)_**

  The resource name of the folder the policy is attached to. Its format is `folders/{folder_id}`.

- **`replicas`**: _(Optional `object(replicas)`)_

  A list of replicas for the secret will be replicated in according to the location set in the location property. If empty The Secret will automatically be replicated without any restrictions.
  Default is `[]`.

  Each `replica` object can have the following fields:

  - **`location`**: **_(Required `string`)_**

    The canonical IDs of the location to replicate data. For example: `"us-east1"`.

  - **`customer_managed_encryption`**: _(Optional `object(customer_managed_encryption)`)_

    Customer Managed Encryption for the secret.
    Default is `[]`.

    Each `replicas` object can have the following field:

    - **`kms_key_name`**: **_(Required `string`)_**

      Describes the Cloud KMS encryption key that will be used to protect destination secret.

- **`rotation`**: _(Optional `object(rotation)`)_

  The rotation time and period for a Secret. At `next_rotation_time`, Secret Manager will send a Pub/Sub notification to the topics configured on the Secret. topics must be set to configure rotation.
  Default is `null`.

  Each `rotation` object can have the following fields:

  - **`next_rotation_time`**: _(Optional `string`)_

    Timestamp in UTC at which the Secret is scheduled to rotate. A timestamp in RFC3339 UTC `"Zulu"` format, with nanosecond resolution and up to nine fractional digits. Examples: `"2014-10-02T15:01:23Z"` and `"2014-10-02T15:01:23.045123456Z"`.
    Default is `null`.

  - **`rotation_period`**: _(Optional `string`)_

    The Duration between rotation notifications. Must be in seconds and at least `3600s (1h)` and at most `3153600000s (100 years)`. If rotationPeriod is set, next_rotation_time must be set. next_rotation_time will be advanced by this period when the service automatically sends rotation notifications.
    Default is `null`.

- **`expire_time`**: _(Optional `string`)_

  Timestamp in UTC when the Secret is scheduled to expire. This is always provided on output, regardless of what was sent on input. A timestamp in RFC3339 UTC `'Zulu'` format, with nanosecond resolution and up to nine fractional digits. Examples: `'2014-10-02T15:01:23Z'` and `'2014-10-02T15:01:23.045123456Z'`.
  Default is `null`.

- **`ttl`**: _(Optional `string`)_

  The TTL for the Secret. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: '3.5s'.
  Default is `true`.

- **`topics`**: _(Optional `set(string)`)_

  A list of up to 10 Pub/Sub topics to which messages are published when control plane operations are called on the secret or its versions. Structure is documented below. If you set topics, you will need to set rotation too.
  Default is `null`.

- **`project`**: _(Optional `string`)_

  The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
  Default is `null`.

- **`labels`**: _(Optional `map(string)`)_

  The labels assigned to this Secret. Label keys must be between 1 and 63 characters long, have a `UTF-8` encoding of maximum 128 bytes, and must conform to the following PCRE regular expression: `'[\\p{Ll}\\p{Lo}][\\p{Ll}\\p{Lo}\\p{N}-]{0,62}'` Label values must be between 0 and 63 characters long, have a UTF-8 encoding of maximum 128 bytes, and must conform to the following PCRE regular expression: `[\\p{Ll}\\p{Lo}\\p{N}-]{0,63}` No more than 64 labels can be assigned to a given resource. An object containing a list of `'key': value pairs`.
  Default is `{}`.

<!-- Example of a required variable:

- **`name`**: **_(Required `string`)_**

  The name of the resource.
  Default is `true`.

-->

<!-- Example of an optional variable:

- **`name`**: _(Optional `string`)_

  The name of the resource.
  Default is `true`.

-->

<!-- Example of an object:
     - We use inline documentation to describe complex objects or lists/maps of complex objects.
     - Please indent each level with 2 spaces so the documentation is rendered in a readable way.

- **`user`**: _(Optional `object(user)`)_

  A user object.
  Default is `true`.

  A/Each `user` object can have the following fields:

  - **`name`**: **_(Required `string`)_**

    The Name of the user.

  - **`description`**: _(Optional `decription`)_

    A description describing the user in more detail.
    Default is "".

  Example
  ```hcl
  user = {
    name        = "marius"
    description = "The guy from Berlin."
  }
  ```
-->

#### Extended Resource Configuration

##### Google secret manager iam

- **`secret_id`**: **_(Required `string`)_**

  The resource name of the folder the policy is attached to. Its format is `folders/{folder_id}`.

- **`members`**: **_(Required `set(string)`)_**

  Identities that will be granted the privilege in role for `'google_secret_manager_secret_iam_binding'`. Each entry can have one of the following values: `'allUsers'`, `'allAuthenticatedUsers'`, `'serviceAccount:{emailid}'`, `'group:{emailid}'`, `'domain:{domain}'`."
  Default is `[]`.

- **`role`**: **_(Required `string`)_**

  The role that should be applied. Only one `'google_secret_manager_secret_iam_binding'` can be used per role. Note that custom roles must be of the format `'[projects|organizations]/{parent-name}/roles/{role-name}'`.

- **`project`**: _(Optional `string`)_

  The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  Default is `null`.

- **`authoritative`**: _(Optional `bool`)_

  Secret manager secret iam choice whether `'authoritative == true'` use `google_secret_manager_secret_iam_binding`, `'authoritative == false'` use `google_secret_manager_secret_iam_member"`.
  Default is `true`.

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`secret`**

  All `google_secret_manager_secret` resource attributes.

## External Documentation

- Google Documentation:
  - Secret Manager: https://cloud.google.com/secret-manager/docs

- Terraform Google Provider Documentation:
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-secret-manager
[hello@mineiros.io]: mailto:hello@mineiros.io


[badge-build]: https://github.com/mineiros-io/terraform-google-secret-manager/workflows/Tests/badge.svg

<!-- markdown-link-check-enable -->

[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-secret-manager.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack


[build-status]: https://github.com/mineiros-io/terraform-google-secret-manager/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-secret-manager/releases

<!-- markdown-link-check-enable -->

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/


[variables.tf]: https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/variables.tf
<!-- [examples/]: https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/examples -->
[issues]: https://github.com/mineiros-io/terraform-google-secret-manager/issues
[license]: https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-secret-manager/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-secret-manager/blob/main/CONTRIBUTING.md

<!-- markdown-link-check-enable -->
