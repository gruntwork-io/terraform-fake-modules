# Terraform Fake Modules for Amazon Web Services (AWS)

Welcome to the repository of Terraform Fake Modules for AWS. This is a collection of mimic AWS Terraform modules designed to simulate real AWS resources. These modules are a great way to explore the behavior of modules in scenarios where deploying real resources isn't feasible or cost-effective. These modules are particularly beneficial when working with infrastructure as code (IaC) orchestration tools like Terragrunt.

In addition to providing a risk-free playground for learning and exploration, these modules are also excellent tools for demonstrations, tutorials, and training sessions. If you're keen on mastering how to test your Terraform code, check out [Terratest](https://terratest.gruntwork.io/), a Swiss-army-knife testing tool for Terraform modules.

## Prerequisites

These modules simulate real AWS resources and do make data calls. Consequently, the following prerequisites apply:

- Valid AWS Credentials
- A correctly configured AWS Provider

With these in place, you'll be able to use these modules to generate semi-realistic outputs corresponding to the resource they mimic.

## Usage

### Basic Usage

```hcl
module "vpc" {
  source      = "git::https://github.com/gruntwork-io/terraform-fake-modules.git//modules/aws/vpc"
  cidr_block  = "10.0.0.0/16"
}
```

## Contributions

We encourage community contributions. If you find an issue or have a suggestion for improving the modules, please open an issue or a pull request. We appreciate any feedback and improvements.

## License

This project is licensed under the terms of the Apache-2.0 license.
