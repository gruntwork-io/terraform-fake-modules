# Terraform Fake AWS EKS Module

This repository includes a fake AWS EKS (Elastic Kubernetes Service) Terraform module. The module is designed to create semi-realistic outputs, mimicking an AWS EKS cluster without deploying any actual infrastructure on AWS. This approach provides a safe environment for learning, testing, and demonstrating behaviors of EKS clusters managed through Terraform.

This module generates a realistic-looking EKS cluster ARN (Amazon Resource Name) and EKS API server endpoint, enabling interactions that resemble actual API calls to an EKS cluster. It utilizes AWS account and region information to create these fake resources.

## Prerequisites

- Terraform v1.0.0 or newer
- An AWS account and valid AWS Credentials
- A correctly configured AWS Provider

## Usage

To use this module, include it in your main Terraform file.

```hcl
module "fake_eks" {
  source  = "git::https://github.com/gruntwork-io/terraform-fake-modules.git//modules/aws/eks"
  vpc_id  = module.fake_vpc.id
}
```

The module takes the following inputs:

- `namespace`: A namespace for unique resource naming
- `environment`: An environment name (e.g., "dev", "staging", "prod")
- `vpc_id`: The fake VPC ID where the EKS cluster will reside

## Outputs

The module generates the following outputs:

- `eks_cluster_name`: The fake name of the EKS cluster
- `eks_cluster_arn`: The fake ARN of the EKS cluster
- `eks_api_server_endpoint`: The fake API server endpoint of the EKS cluster

## Contributions

Contributions to this module are always welcome! If you find an issue or have a suggestion for improving the module, please open an issue or a pull request.

## License

This module is licensed under the terms of the Apache-2.0 license.
