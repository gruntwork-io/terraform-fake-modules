# Terraform Fake Modules
A collection of "fake" Terraform modules that authenticate to Amazon Web Services (AWS) or Google Cloud Platform (GCP) that output semi-realistic values you can use to explore Terragrunt and Terraform behavior without having to spend money on and waste time waiting for real infrastrucure.

### Quickly get started

For a fake AWS Virtual Private Cloud (VPC):
```
module "vpc" {
  source = "git@github.com:gruntwork-io/terraform-fake-modules.git//modules/aws/vpc?ref=main"
}
```

For a fake AWS Elastic Kubernetes Service (EKS) cluster:
```
module "eks" {
  source = "git@github.com:gruntwork-io/terraform-fake-modules.git//modules/aws/eks?ref=main"

  vpc_id = module.vpc.id
}
```
