# {{.ProjectName}}-multiaccount-structure

This repository contains the Terragrunt configuration for managing AWS infrastructure across multiple accounts.

## Structure

- `live/` - Contains live infrastructure configurations organized by account and region
- `modules/` - Contains reusable Terraform modules
- `project.hcl` - Project-wide configuration and variables
- `root.hcl` - Root Terragrunt configuration for state management and provider setup

## Accounts

- **development**: aws+development@{{.DomainName}} ({{.DevelopmentAccountId}})
- **management**: aws+management@{{.DomainName}} ({{.ManagementAccountId}})
- **monitoring**: aws+monitoring@{{.DomainName}} ({{.MonitoringAccountId}})
- **production**: aws+production@{{.DomainName}} ({{.ProductionAccountId}})

## Usage

```bash
# Initialize and plan
cd live/development/us-east-1/vpc
terragrunt plan

# Apply changes
terragrunt apply

# Apply across all modules in an environment
terragrunt run-all apply