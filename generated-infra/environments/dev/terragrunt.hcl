include "root" {
  path = find_in_parent_folders()
}

locals {
  environment = "dev"
  vpc_cidr = "10.0.0.0/16"
}

inputs = {
  vpc_cidr = local.vpc_cidr
}