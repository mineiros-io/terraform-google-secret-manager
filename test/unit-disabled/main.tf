module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments

  secret_id = "myseceret"

  # add all optional arguments that create additional/extended resources
  iam = [
    {
      role    = "roles/viewer"
      members = ["user:member@example.com"]
    },
    {
      roles = [
        "myCustomRole1of2",
        "myCustomRole2of2",
      ]
      members = ["user:member@example.com"]
    },
    {
      roles = [
        "myOtherCustomRole1of2",
        "myOtherCustomRole2of2",
      ]
      members = [
        "user:member1@example.com",
        "user:member2@example.com",
      ]
      authoritative = false
    }
  ]
}
