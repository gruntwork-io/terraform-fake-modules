# Terraform Fake Modules

This repository contains a collection of "fake" Terraform modules designed to mimic AWS and GCP resources. The main purpose of these modules is to facilitate the exploration of Terraform and Terragrunt behavior without the need to invest time or money in real infrastructure. Each module authenticates with the respective cloud service and generates semi-realistic output values. It is currently maintained by members of the [Gruntwork](https://gruntwork.io/) sales team. 

## Prerequisites

- Terraform v1.0.0 or newer
- AWS Provider version 4.0 or newer
- Terragrunt v0.31.0 or newer (Optional)
- Git

For the compatibility between Terraform and Terragrunt versions, please refer to the [Terragrunt Supported Terraform Versions](https://terragrunt.gruntwork.io/docs/getting-started/supported-terraform-versions/) documentation.

## Quick Start

### AWS Virtual Private Cloud (VPC)

To quickly get started with a fake AWS VPC, use the following code:

```hcl
module "vpc" {
  source = "https://github.com/gruntwork-io/terraform-fake-modules.git//modules/aws/vpc?ref=main"
}
```

### AWS Elastic Kubernetes Service (EKS)

To add a fake AWS EKS cluster, you can use the following code. This also uses the output from the fake VPC module:

```hcl
module "eks" {
  source = "https://github.com/gruntwork-io/terraform-fake-modules.git//modules/aws/eks?ref=main"
  vpc_id = module.vpc.id
}
```

### Terragrunt

To use these modules with Terragrunt, you need to define the `terraform` block in your `terragrunt.hcl` file and specify the module source as follows:

```hcl
terraform {
  source = "https://github.com/gruntwork-io/terraform-fake-modules.git//modules/aws/vpc?ref=main"
}

inputs = {}
```

## What to Expect

These modules do not create any real cloud resources. They simulate the process and generate fake outputs. You can use them to learn and understand how to structure Terraform modules, manage module dependencies, and study how Terragrunt simplifies working with Terraform modules.

Here is the output from the `examples/vpc-aurora-eks` example module:

```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

aurora = {
  "arn" = "arn:aws:rds:eu-west-1:012345678901:cluster:fake-module-development-euw1-aurora-postgres"
  "engine" = {
    "name" = "postgres"
    "version" = "13.6"
  }
  "name" = "fake-module-development-euw1-aurora-postgres"
  "port" = "5432"
  "reader_endpoint" = "fake-module-development-euw1-aurora-postgres.cluster-ro-5b07ca0def49.eu-west-1.rds.amazonaws.com"
  "writer_endpoint" = "fake-module-development-euw1-aurora-postgres.cluster-5b07ca0def49.eu-west-1.rds.amazonaws.com"
}
eks = {
  "api_server_endpoint" = "https://5B07CA0DEF491592E25413C44895381E.8f2.eu-west-1.eks.amazonaws.com"
  "arn" = "arn:aws:eks:eu-west-1:012345678901:cluster/fake-module-development-euw1-eks"
  "name" = "fake-module-development
