# {{.ProjectName}}-multiaccount-structure

This repository contains the Terragrunt configuration for managing AWS infrastructure across multiple accounts.

## Project Configuration

- **Project**: {{.ProjectName}} ({{.ProjectVersion}})
- **Organization**: {{.OrganizationId}}
- **Default Region**: {{.DefaultRegion}}
- **State Storage Region**: {{.StateRegion}}
{{if eq .CreateVPC "true"}}
- **VPC CIDR**: {{.VPCCidr}}
{{end}}

## Directory Structure

```
live/
├── development/          # Development environment
{{if eq .CreateVPC "true"}}│   ├── us-east-1/
│   │   ├── env.hcl      # Environment configuration with VPC
│   │   └── vpc/         # VPC infrastructure
│   └── eu-west-1/       # European region
│       ├── env.hcl      # Environment configuration with VPC
│       └── vpc/         # VPC infrastructure{{else}}│   └── us-east-1/
│       └── env.hcl      # Environment configuration{{end}}
├── management/           # Management account
│   └── us-east-1/
│       └── env.hcl      # Environment configuration
├── monitoring/           # Monitoring account  
│   └── us-east-1/
│       └── env.hcl      # Environment configuration
├── production/           # Production environment
│   └── us-east-1/
│       └── env.hcl      # Environment configuration
└── modules/              # Reusable Terraform modules
    ├── s3/
    └── vpc/
```

## AWS Accounts

The following AWS accounts are configured for this project:

- **development**: aws+development@{{.DomainName}} ({{.DevelopmentAccountId}})
  {{if eq .CreateVPC "true"}}- VPC enabled in us-east-1 and eu-west-1{{else}}- Basic configuration only{{end}}
- **management**: aws+management@{{.DomainName}} ({{.ManagementAccountId}})
  - Basic configuration only
- **monitoring**: aws+monitoring@{{.DomainName}} ({{.MonitoringAccountId}})
  - Basic configuration only  
- **production**: aws+production@{{.DomainName}} ({{.ProductionAccountId}})
  - Basic configuration only

## Infrastructure Components

### Core Components
**Multi-account structure** - Separate AWS accounts for different environments
**Terragrunt configuration** - DRY infrastructure with shared configurations
**Remote state management** - S3 backend with DynamoDB locking
**Cross-account roles** - IAM roles for Terragrunt execution

{{if eq .CreateVPC "true"}}### Networking (Development Only)
**VPC** - Virtual Private Cloud with {{.VPCCidr}} CIDR
**Multi-AZ setup** - Subnets across multiple availability zones
**NAT Gateway** - Single NAT gateway for cost optimization
**DNS support** - DNS hostnames and resolution enabled
**Internet Gateway** - Public internet access
**Egress-only Gateway** - IPv6 egress for private subnets

### Network Architecture
```
{{.VPCCidr}} VPC
├── Private Subnets (for workloads)
│   ├── us-east-1a: 10.0.0.0/20
│   ├── us-east-1b: 10.0.16.0/20  
│   └── us-east-1c: 10.0.32.0/20
└── Public Subnets (for NAT/ALB)
    ├── us-east-1a: 10.0.48.0/24
    ├── us-east-1b: 10.0.49.0/24
    └── us-east-1c: 10.0.50.0/24
```
{{end}}

## Quick Start

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terragrunt installed
- Terraform installed

### Usage

{{if eq .CreateVPC "true"}}#### Deploy VPC Infrastructure
```bash
cd live/development/us-east-1/vpc

terragrunt plan

terragrunt apply

cd ../../../eu-west-1/vpc
terragrunt apply
```

#### Deploy Across All Development Infrastructure
```bash
cd live/development
terragrunt run-all apply
```
{{else}}#### Basic Environment Setup
```bash
cd live/development/us-east-1

terragrunt init

```
{{end}}

#### Cross-Account Operations
```bash
terragrunt run-all apply

terragrunt run-all plan

terragrunt run-all destroy
```

## Configuration Files

- **`project.hcl`** - Project-wide variables and settings
- **`root.hcl`** - Remote state and provider configuration  
- **`account.hcl`** - Account-specific variables (per account)
- **`env.hcl`** - Environment and region-specific variables

## State Management

Terraform state is stored in S3 with the following naming convention:
- **Bucket**: `{{.ProjectName}}-{account}-terraform-state`
- **DynamoDB Table**: `{{.ProjectName}}-{account}-terraform-state-lock`
- **Region**: {{.StateRegion}}

## Adding New Infrastructure

{{if eq .CreateVPC "true"}}### Adding Modules to VPC
To add new infrastructure that uses the VPC:

1. Create a new module directory under `modules/`
2. Add the module configuration to the appropriate environment
3. Reference VPC outputs using `dependency` blocks

Example:
```hcl
dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnets
}
```
{{else}}### Adding Infrastructure Modules
To add new infrastructure:

1. Create modules under `modules/` directory
2. Add configurations to specific environments under `live/`
3. Use Terragrunt dependencies to link related resources
{{end}}

### Adding New Accounts
To add a new AWS account:

1. Update the main `boilerplate.yml` with new account variables
2. Add a new dependency for the account
3. Re-run boilerplate to generate the structure

### Adding New Regions
To add support for new regions:

1. Create new region directories under each account
2. Copy and modify `env.hcl` with region-specific settings  
3. Update availability zones and region-specific resources