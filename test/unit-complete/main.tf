# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPLETE FEATURES UNIT TEST
# This module tests a complete set of most/all non-exclusive features
# The purpose is to activate everything the module offers, but trying to keep execution time and costs minimal.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.2.1"

  account_id = "service-account-id-${local.random_suffix}"
}

module "test" {
  source         = "../.."
  module_enabled = true

  # add all required arguments
  secret_id = "unit-complete-1-${local.random_suffix}"

  # add all optional arguments that create the module resources
  project = var.gcp_project
  replicas = [
    {
      location = "us-central1"
      customer_managed_encryption = {
        kms_key_name = "mykey"
      }
    },
    {
      location = "us-central2"
    }
  ]

  labels = {
    foo = "bar"
    baz = "foo"
  }

  expire_time = "2014-10-02T15:01:23.045123456Z"
  ttl         = "3.5s"
  topics      = ["pst0", "pst1"]
  rotation = {
    next_rotation_time = "2022-10-02T15:01:23.045123456Z"
    rotation_period    = "3600s"
  }

  # add all optional arguments that create additional resources
  iam = [
    ### authoritative tests
    # when authoritative is true we do not need computed map
    {
      role = "roles/dummyRole0"
      members = [
        "serviceAccount:${module.test-sa.service_account.email}",
      ]
      authoritative = true
    },
    {
      roles = [
        "roles/dummyRole0.1",
        "roles/dummyRole0.2",
      ]
      members = [
        "serviceAccount:${module.test-sa.service_account.email}",
      ]
      authoritative = true
    },
    {
      role          = "roles/dummyRole1"
      authoritative = true
    },
    {
      roles = [
        "roles/dummyRole1.1",
        "roles/dummyRole1.2",
      ]
      authoritative = true
    },

    ### authoritative tests
    # default
    {
      role = "roles/dummyRole2"
      members = [
        "serviceAccount:${module.test-sa.service_account.email}",
      ]
    },
    {
      roles = [
        "roles/dummyRole2.0",
        "roles/dummyRole2.1",
      ]
      members = [
        "serviceAccount:${module.test-sa.service_account.email}",
      ]
    },
    {
      role = "roles/dummyRole3"
    },
    {
      roles = [
        "roles/dummyRole3.1",
        "roles/dummyRole3.2",
      ]
    },

    ### non authoritative tests
    {
      role = "roles/dummyRole4"
      members = [
        "computed:myserviceaccount",
      ]
      authoritative = false
    },
    {
      roles = [
        "roles/dummyRole4.1",
        "roles/dummyRole4.2",
      ]
      members = [
        "computed:myserviceaccount",
      ]
      authoritative = false
    },
    {
      role          = "roles/dummyRole5"
      authoritative = false
    },
    {
      roles = [
        "roles/dummyRole5.1",
        "roles/dummyRole5.2",
      ]
      authoritative = false
    }
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  module_depends_on = ["nothing"]
}

module "test2" {
  source = "../.."

  module_enabled = true

  secret_id = "unit-complete-2-${local.random_suffix}"

  policy_bindings = [
    {
      role = "roles/dummyRole0"
      members = [
        "computed:myserviceaccount",
        "serviceAccount:${module.test-sa.service_account.email}",
      ]
      authoritative = false
    },
    {
      role = "roles/dummyRole1"
      members = [
        "group:terraform-tests@mineiros.io",
      ]
      condition = {
        title       = "expires_after_2030_12_31"
        description = "Expiring at midnight of 2030-12-31"
        expression  = "request.time < timestamp(\"2030-01-01T00:00:00Z\")"
      }
    }
  ]
}
