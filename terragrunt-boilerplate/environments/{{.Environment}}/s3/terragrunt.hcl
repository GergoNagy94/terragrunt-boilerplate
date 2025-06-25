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
  bucket = "${include.env.inputs.project_name}-${include.env.inputs.environment}-{{.S3BucketPurpose}}-${random_string.bucket_suffix.result}"
  
  # Bucket configuration
  force_destroy = {{if eq .Environment "prod"}}false{{else}}true{{end}}
  
  # Versioning
  versioning = {
    enabled = {{if eq .Environment "prod"}}true{{else}}false{{end}}
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
  
{{- if eq .Environment "prod" }}
  lifecycle_configuration = {
    rule = [
      {
        id     = "transition_to_ia"
        status = "Enabled"
        
        transition = [
          {
            days          = 30
            storage_class = "STANDARD_IA"
          },
          {
            days          = 90
            storage_class = "GLACIER"
          }
        ]
      }
    ]
  }
{{- end }}

  tags = merge(
    include.env.inputs.common_tags,
    {
      Name        = "${include.env.inputs.project_name}-${include.env.inputs.environment}-{{.S3BucketPurpose}}"
      Purpose     = "{{.S3BucketPurpose}}"
      Environment = "{{.Environment}}"
    }
  )
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}