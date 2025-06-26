locals {
    project_vars  = read_terragrunt_config(find_in_parent_folders("project.hcl"))
    account_vars  = read_terragrunt_config(find_in_parent_folders("account.hcl"))

    project         = local.project_vars.locals.project
    project_version = local.project_vars.locals.project_version
    default_region  = local.project_vars.locals.default_region

    account_id = local.account_vars.locals.account_id
    env        = local.account_vars.locals.account
      
    region = "eu-west-1"

{{if .CreateVPC}}    skip_module = {
        vpc = false
    } 

    # VPC variables
    vpc_cidr                             = "{{.VPCCidr}}"
    vpc_nat_gateway                      = true
    vpc_single_nat_gateway               = true
    vpc_create_egress_only_igw           = true
    vpc_enable_dns_hostnames             = true
    vpc_enable_dns_support               = true
    availability_zone                    = ["eu-west-1a", "eu-west-1b"]
{{else}}    skip_module = {}
{{end}}

    tags = {
      createdBy       = "Terragrunt" 
      environment     = "${local.env}" 
      project         = "${local.project}"
      project-version = "${local.project_version}"  
    }
}