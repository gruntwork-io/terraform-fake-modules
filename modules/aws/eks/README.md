# Terraform Fake AWS EKS Module

This repository includes a fake AWS EKS (Elastic Kubernetes Service) Terraform module. The module simulates the creation of an EKS cluster and generates semi-realistic outputs, without deploying any actual infrastructure on AWS. This approach provides a safe and cost-efficient environment for learning, testing, and demonstrating behaviors of EKS clusters managed through Terraform.

This module generates a realistic-looking EKS cluster name, ARN (Amazon Resource Name), and API server endpoint, enabling interactions that resemble actual API calls to an EKS cluster. It utilizes current AWS account and region information to simulate the creation of these resources.

## Prerequisites

- Terraform v1.x or newer
- AWS Provider version 4.0 or newer
- An AWS account with valid AWS Credentials

## Usage

To use this module, include it in your main Terraform file.

```hcl
module "fake_eks" {
  source                 = "git::https://github.com/gruntwork-io/terraform-fake-modules.git//modules/aws/eks"
  vpc_id                 = "vpc-12345"
  namespace              = "gruntwork"
  environment            = "staging"
  allow_list_cidr_blocks = ["192.0.2.0/24", "198.51.100.0/24"]
  tags = {
    "Owner"   = "Test User"
    "Purpose" = "Module Testing"
  }
}

```

## Inputs

The module takes the following inputs:

- `vpc_id`: The ID of the VPC where the EKS cluster will reside. Required.
- `namespace`: A namespace to use for naming and tagging resources. Default: "grunty".
- `environment`: An environment name (e.g., "development", "staging", "production"). Default: "development".
- `allow_list_cidr_blocks`: A list of CIDR blocks to simulate allowing access to the EKS cluster. Default: ["0.0.0.0/0"].
- `tags`: A map of tags to add to the resources. Default: {}.

## Outputs

The module generates the following outputs:

- `id`: The fake ID of the EKS cluster.
- `name`: The fake name of the EKS cluster.
- `arn`: The fake ARN of the EKS cluster.
- `api_server_endpoint`: The fake API server endpoint of the EKS cluster.

## Contributions

Contributions to this module are always welcome and appreciated. If you encounter an issue or have a suggestion for improving the module, feel free to open an issue or a pull request.

## License

This module is open-source and licensed under the terms of the Apache-2.0 license.
