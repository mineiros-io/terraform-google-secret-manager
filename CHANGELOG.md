# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Upgrading all test dependencies to mitigate [ CVE-2024-3817](https://github.com/advisories/GHSA-q64h-39hv-4cf7). Thanks to @ckluente-1k5 for reporting and fixing this.

## [0.3.0]

### Added

- Add support for `computed_members_map`

### Removed

- BREAKING CHANGE: remove support for google provider `3.x`
- BREAKING CHANGE: remove output `module_enabled`

## [0.2.0] BREAKING CHANGE

### Changed

- BREAKING CHANGE: IAM config rewritten. Resources might get recreated.

## [0.1.4]

### Fixed

- `Error: No value was found for project during import`

## [0.1.3]

### Added

- Support empty members list in policy_bindings

## [0.1.2]

### Fixed

- unsupported attribute when using policy_bindings

## [0.1.1]

### Added

- Support for provider 4.x

## [0.1.0]

### Added

- Initial Implementation

<!-- markdown-link-check-disable -->

[unreleased]: https://github.com/mineiros-io/terraform-google-secret-manager/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/mineiros-io/terraform-google-secret-manager/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mineiros-io/terraform-google-secret-manager/compare/v0.1.4...v0.2.0
[0.1.4]: https://github.com/mineiros-io/terraform-google-secret-manager/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/mineiros-io/terraform-google-secret-manager/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/mineiros-io/terraform-google-secret-manager/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/mineiros-io/terraform-google-secret-manager/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/mineiros-io/terraform-google-secret-manager/releases/tag/v0.1.0

<!-- markdown-link-check-disabled -->
