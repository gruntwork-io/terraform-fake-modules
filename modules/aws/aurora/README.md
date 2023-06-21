# Terraform Fake AWS Aurora Module

Welcome to the repository of the fake AWS Aurora Terraform module! The primary aim of this module is to provide an environment where you can mimic an AWS Aurora cluster without deploying any actual infrastructure on AWS. This can be highly beneficial for learning, testing, and developing purposes.

This module generates semi-realistic Aurora endpoints for both writer and reader nodes, using region and account information. It's perfect for replicating and understanding the behavior of Aurora databases managed through Terraform.

## Prerequisites

- Terraform v1.0.0 or newer
- An AWS account and valid AWS Credentials
- AWS Provider version 4.0 or newer

## Usage

Include this module in your main Terraform file as follows:

```hcl
module "fake_aurora" {
  source  = "git::https://github.com/gruntwork-io/terraform-fake-modules.git//modules/aws/aurora"
  vpc_id                 = "vpc-12345"
  namespace              = "gruntwork"
  environment            = "staging"
  tags = {
    "Owner"   = "Test User"
    "Purpose" = "Module Testing"
  }
}
```

Replace the `region` value with your AWS region where you want the fake Aurora cluster to be created.

The module accepts the following inputs:

- `namespace`: A namespace for unique resource naming
- `environment`: An environment name (e.g., "dev", "staging", "prod")
- `vpc_id`: The fake VPC ID where the Aurora cluster will reside
- `engine_name`: Name of the database engine to be used
- `engine_version`: Version of the database engine
- `tags`: Any additional tags that you want to add

## Outputs

The module produces the following outputs:

- `id`, `name`: The fake ID and name of the Aurora cluster
- `arn`: The fake ARN of the Aurora cluster
- `writer_endpoint`, `reader_endpoint`: The fake writer and reader endpoints of the Aurora cluster
- `aws_region`, `aws_region_shortname`: The current AWS region and its shortname
- `environment`, `namespace`: The environment and namespace passed as variables
- `vpc_id`: The fake VPC ID where the Aurora cluster resides
- `engine_name`, `engine_version`: The database engine name and version
- `port`: The port number (5432 by default)
- `tags`: Any additional tags that you have added

## Contributions

Contributions are always welcome! Please feel free to report an issue or submit a pull request if you have something to add or notice something that could be better.

## License

This module is licensed under the Apache-2.0 License.
