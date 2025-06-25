locals {
  project_name = "boilerplate"
  aws_region   = "us-west-2"
  
  common_tags = {
    Project     = "boilerplate"
    Environment = "dev"
    ManagedBy   = "Terragrunt"
  }
}

remote_state {
  backend = "s3"
  
  config = {
    encrypt        = true
    bucket         = "state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "locker"
  }
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  
  default_tags {
    tags = {
      Project     = "boilerplate"
      Environment = "dev"
      ManagedBy   = "Terragrunt"
    }
  }
}
EOF
}

inputs = {
  project_name = local.project_name
  environment  = "dev"
  aws_region   = local.aws_region
  common_tags  = local.common_tags
}