terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v3.15.0"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

inputs = {
  bucket = "${include.env.inputs.project_name}-${include.env.inputs.environment}-data-storage-${random_string.bucket_suffix.result}"
  
  # Bucket configuration
  force_destroy = true
  
  # Versioning
  versioning = {
    enabled = false
  }
  
  # Server-side encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  
  # Block public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = merge(
    include.env.inputs.common_tags,
    {
      Name        = "${include.env.inputs.project_name}-${include.env.inputs.environment}-data-storage"
      Purpose     = "data-storage"
      Environment = "dev"
    }
  )
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}