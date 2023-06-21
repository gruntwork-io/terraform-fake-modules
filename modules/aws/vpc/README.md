# Terraform Fake AWS VPC Module

This repository contains a fake AWS VPC Terraform module designed to generate semi-realistic outputs mimicking AWS VPC resources. The main objective of this module is to facilitate exploration of Terraform and infrastructure orchestration tools like Terragrunt without the need to deploy real infrastructure on AWS, thereby saving time and cost.

This module simulates a VPC with associated resources such as subnets (both private and public), internet gateway, and NAT gateways. The module uses AWS region and availability zone data to generate unique, fake IDs for VPC and subnet resources.

## Prerequisites

- Terraform v1.0.0 or newer
- An AWS account and valid AWS Credentials
- A correctly configured AWS Provider

## Usage

To use this module, include it in your main Terraform file.

```hcl
module "fake_vpc" {
  source       = "git::https://github.com/gruntwork-io/terraform-fake-modules.git//modules/aws/vpc"
  environment  = "development"
}
```

Please make sure you replace the `region` value with the AWS region where you want the fake VPC to be created.

The module takes the following inputs:

- `namespace`: A namespace to use for unique resource naming
- `environment`: An environment name (e.g., "dev", "staging", "prod")
- `cidr_block`: The CIDR block for the VPC
- `max_az_count`: The maximum number of Availability Zones in which to create subnets
- `tags`: Additional tags to add to the resources

## Outputs

The module generates the following outputs:

- `vpc_id`: The fake ID of the VPC
- `private_subnet_ids`: A list of fake IDs for the private subnets
- `public_subnet_ids`: A list of fake IDs for the public subnets
- `subnet_ids`: A list of all subnet fake IDs
- `subnet_names`: A map of subnet IDs to their names
- `subnet_cidr_blocks`: A map of subnet names to their CIDR blocks
- `subnet_id_cidr_blocks`: A map of subnet IDs to their CIDR blocks

## Contributions

Contributions to this module are welcome! If you find an issue or have a suggestion for improving the module, please open an issue or a pull request.

## License

This module is licensed under the terms of the Apache-2.0 license.
