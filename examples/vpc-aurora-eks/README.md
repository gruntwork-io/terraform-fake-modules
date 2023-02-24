# Terraform Fake Modules for Amazon Web Services - Fake VPC, Aurora Postgres, EKS example

A collection of fake AWS Terraform modules for example purposes when you need to demonstrate module behavior with tools like Terragrunt. Don't use these modules for testing, stubbing, or production. See [Terratest](https://terratest.gruntwork.io/) for how to effectively test Terraform.

## Requirements

These modules do make `data` calls, so you will need to have AWS credentials and a provider is required.

## Testing Locally
These modules do not create any real resources, but still require AWS authorization.

### Plan Example
```
terraform-fake-modules/examples/vpc-aurora-eks $ aws-vault exec development-environment --region eu-west-1 -- terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.aurora.null_resource.aurora_cluster will be created
  + resource "null_resource" "aurora_cluster" {
      + id       = (known after apply)
      + triggers = {
          + "destroy_aurora_if_name_changed"   = "fake-module-development-euw1-aurora-postgres"
          + "destroy_aurora_if_region_changed" = "eu-west-1"
          + "destroy_aurora_if_vpc_changed"    = "vpc-14d5670"
        }
    }

  # module.eks.null_resource.eks_cluster will be created
  + resource "null_resource" "eks_cluster" {
      + id       = (known after apply)
      + triggers = {
          + "destroy_eks_if_name_changed"   = "fake-module-development-euw1-eks"
          + "destroy_eks_if_region_changed" = "eu-west-1"
          + "destroy_eks_if_vpc_changed"    = "vpc-14d5670"
        }
    }

  # module.vpc.null_resource.internet_gateway will be created
  + resource "null_resource" "internet_gateway" {
      + id       = (known after apply)
      + triggers = {
          + "destroy_vpc_if_cidr_changed"   = "10.0.0.0/16"
          + "destroy_vpc_if_name_changed"   = "fake-module-development-euw1-vpc"
          + "destroy_vpc_if_region_changed" = "eu-west-1"
        }
    }

  # module.vpc.null_resource.private_subnets will be created
  + resource "null_resource" "private_subnets" {
      + id       = (known after apply)
      + triggers = {
          + "destroy_subnets_if_subnet_count_changed" = "4"
          + "destroy_subnets_if_subnet_ids_changed"   = "subnet-55b7bc5"
          + "destroy_vpc_if_cidr_changed"             = "10.0.0.0/16"
          + "destroy_vpc_if_name_changed"             = "fake-module-development-euw1-vpc"
          + "destroy_vpc_if_region_changed"           = "eu-west-1"
        }
    }

  # module.vpc.null_resource.public_subnets will be created
  + resource "null_resource" "public_subnets" {
      + id       = (known after apply)
      + triggers = {
          + "destroy_subnets_if_subnet_count_changed" = "4"
          + "destroy_subnets_if_subnet_ids_changed"   = "subnet-55b7bc5"
          + "destroy_vpc_if_cidr_changed"             = "10.0.0.0/16"
          + "destroy_vpc_if_name_changed"             = "fake-module-development-euw1-vpc"
          + "destroy_vpc_if_region_changed"           = "eu-west-1"
        }
    }

  # module.vpc.null_resource.vpc will be created
  + resource "null_resource" "vpc" {
      + id       = (known after apply)
      + triggers = {
          + "destroy_vpc_if_cidr_changed"   = "10.0.0.0/16"
          + "destroy_vpc_if_name_changed"   = "fake-module-development-euw1-vpc"
          + "destroy_vpc_if_region_changed" = "eu-west-1"
        }
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + aurora = {
      + arn             = "arn:aws:rds:eu-west-1:012345678901:cluster:fake-module-development-euw1-aurora-postgres"
      + engine          = {
          + name    = "postgres"
          + version = "13.6"
        }
      + name            = "fake-module-development-euw1-aurora-postgres"
      + port            = "5432"
      + reader_endpoint = "fake-module-development-euw1-aurora-postgres.cluster-ro-02838a0a4b96.eu-west-1.rds.amazonaws.com"
      + writer_endpoint = "fake-module-development-euw1-aurora-postgres.cluster-02838a0a4b96.eu-west-1.rds.amazonaws.com"
    }
  + eks    = {
      + api_server_endpoint = "https://02838A0A4B963319947C4C452F5DEBAB.be7.eu-west-1.eks.amazonaws.com"
      + arn                 = "arn:aws:eks:eu-west-1:012345678901:cluster/fake-module-development-euw1-eks"
      + name                = "fake-module-development-euw1-eks"
    }
  + vpc    = {
      + id                 = "vpc-14d5670"
      + name               = "fake-module-development-euw1-vpc"
      + subnet_cidr_blocks = {
          + fake-module-development-euw1-private-subnet-1 = "10.0.0.0/20"
          + fake-module-development-euw1-private-subnet-3 = "10.0.32.0/20"
          + fake-module-development-euw1-public-subnet-2  = "10.0.16.0/20"
          + fake-module-development-euw1-public-subnet-4  = "10.0.48.0/20"
        }
      + subnet_names       = {
          + subnet-55b7bc5 = "fake-module-development-euw1-private-subnet-1"
          + subnet-5b7bc58 = "fake-module-development-euw1-public-subnet-2"
          + subnet-7bc5817 = "fake-module-development-euw1-public-subnet-4"
          + subnet-b7bc581 = "fake-module-development-euw1-private-subnet-3"
        }
    }

```

# Apply Example
```
terraform-fake-modules/examples/vpc-aurora-eks $ aws-vault exec development-environment --region eu-west-1 -- terraform apply -auto-approve -var vpc_cidr_block="10.222.0.0/17" -var subnet_count=2
...
module.aurora.null_resource.aurora_cluster: Creating...
module.eks.null_resource.eks_cluster: Creating...
module.vpc.null_resource.vpc: Creating...
module.vpc.null_resource.private_subnets: Creating...
module.vpc.null_resource.internet_gateway: Creating...
module.vpc.null_resource.public_subnets: Creating...
module.vpc.null_resource.internet_gateway: Creation complete after 0s [id=4060241388265511200]
module.vpc.null_resource.private_subnets: Creation complete after 0s [id=3072974726805666466]
module.aurora.null_resource.aurora_cluster: Creation complete after 0s [id=1711341299109408259]
module.vpc.null_resource.vpc: Creation complete after 0s [id=2798850878183296913]
module.vpc.null_resource.public_subnets: Creation complete after 0s [id=9084468925739249121]
module.eks.null_resource.eks_cluster: Creation complete after 0s [id=899002398305966149]

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
  "name" = "fake-module-development-euw1-eks"
}
vpc = {
  "id" = "vpc-4d23c34"
  "name" = "fake-module-development-euw1-vpc"
  "subnet_cidr_blocks" = {
    "fake-module-development-euw1-private-subnet-1" = "10.222.0.0/21"
    "fake-module-development-euw1-public-subnet-2" = "10.222.8.0/21"
  }
  "subnet_names" = {
    "subnet-757c89b" = "fake-module-development-euw1-public-subnet-2"
    "subnet-8757c89" = "fake-module-development-euw1-private-subnet-1"
  }
}
```

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
