module "test" {
  source = "../.."

  # add only required arguments and no optional arguments

  secret_id = "myseceret-${local.random_suffix}"
}
