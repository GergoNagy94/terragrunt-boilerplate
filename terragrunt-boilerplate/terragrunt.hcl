locals {
  project_name = "{{.ProjectName}}"
  aws_region   = "{{.AWSRegion}}"
  
  common_tags = {
    Project     = "{{.ProjectName}}"
    Environment = "{{.Environment}}"
    ManagedBy   = "Terragrunt"
  }
}

remote_state {
  backend = "s3"
  
  config = {
    encrypt        = true
    bucket         = "{{.TerraformStateS3Bucket}}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "{{.AWSRegion}}"
    dynamodb_table = "{{.TerraformStateDynamoDBTable}}"
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
  region = "{{.AWSRegion}}"
  
  default_tags {
    tags = {
      Project     = "{{.ProjectName}}"
      Environment = "{{.Environment}}"
      ManagedBy   = "Terragrunt"
    }
  }
}
EOF
}

inputs = {
  project_name = local.project_name
  environment  = "{{.Environment}}"
  aws_region   = local.aws_region
  common_tags  = local.common_tags
}