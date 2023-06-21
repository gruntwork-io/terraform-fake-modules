# Terraform Fake Modules

This repository contains a collection of "fake" Terraform modules designed to mimic AWS and GCP resources. The main purpose of these modules is to facilitate the exploration of Terraform and Terragrunt behavior without the need to invest time or money in real infrastructure. Each module authenticates with the respective cloud service and generates semi-realistic output values.

## Prerequisites

- Terraform v1.0.0 or newer
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

## Contributing

Contributions to this project are welcome! Please submit a pull request or create an issue to propose changes or additions.

## License

This project is licensed under the terms of the Apache-2.0 license.
