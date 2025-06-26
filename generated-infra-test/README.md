# terragrunt-multiaccount-structure

This repository contains the Terragrunt configuration for managing AWS infrastructure across multiple accounts.

## Structure

- `live/` - Contains live infrastructure configurations organized by account and region
- `modules/` - Contains reusable Terraform modules
- `project.hcl` - Project-wide configuration and variables
- `root.hcl` - Root Terragrunt configuration for state management and provider setup

## Accounts

- **development**: aws+development@example.com (000000000000)
- **management**: aws+management@example.com (000000000000)
- **monitoring**: aws+monitoring@example.com (000000000000)
- **production**: aws+production@example.com (000000000000)

## Usage

```bash
# Initialize and plan
cd live/development/us-east-1/vpc
terragrunt plan

# Apply changes
terragrunt apply

# Apply across all modules in an environment
terragrunt run-all apply