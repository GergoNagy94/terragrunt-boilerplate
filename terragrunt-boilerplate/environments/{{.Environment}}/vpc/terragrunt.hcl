terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v5.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

inputs = {
  name = "${include.env.inputs.project_name}-${include.env.inputs.environment}-vpc"
  cidr = include.env.inputs.vpc_cidr

  azs = ["{{.AWSRegion}}a", "{{.AWSRegion}}b"]
  
  private_subnets = [
    cidrsubnet(include.env.inputs.vpc_cidr, 8, 1), 
    cidrsubnet(include.env.inputs.vpc_cidr, 8, 2)
  ]
  public_subnets = [
    cidrsubnet(include.env.inputs.vpc_cidr, 8, 101), 
    cidrsubnet(include.env.inputs.vpc_cidr, 8, 102)
  ]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    include.env.inputs.common_tags,
    {
      Name = "${include.env.inputs.project_name}-${include.env.inputs.environment}-vpc"
    }
  )
}