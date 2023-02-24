# Terraform Fake Modules for Amazon Web Services (AWS) - Fake Virtual Private Cloud (VPC) example

A collection of fake AWS Terraform modules for example purposes when you need to demonstrate module behavior with tools like Terragrunt. Don't use these modules for testing or production. See [Terratest](https://terratest.gruntwork.io/) for how to effectively test Terraform.

### Requirements

These modules do make `data` calls, so you will need to have AWS credentials and a provider is required.

### Testing Locally
These modules do not create any real resources, but still require AWS authorization.

```
terraform-fake-modules/examples/vpc $ aws-vault exec development-environment --region eu-west-1 -- terraform plan
```
