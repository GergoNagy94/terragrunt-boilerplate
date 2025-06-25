include "root" {
  path = find_in_parent_folders()
}

locals {
  environment = "{{.Environment}}"
  vpc_cidr = "{{.VPCCidr}}"
}

inputs = {
  vpc_cidr = local.vpc_cidr
}