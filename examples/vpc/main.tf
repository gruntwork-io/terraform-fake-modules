terraform {
  required_version = ">= 1.1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  alias = "this"
}

module "vpc" {
  source = "./../../modules/aws/vpc"

  providers = {
    aws = aws.this
  }
}

output "vpc" {
  value = {
    id                 = module.vpc.id,
    name               = module.vpc.name
    subnet_cidr_blocks = module.vpc.subnet_cidr_blocks
    subnet_names       = module.vpc.subnet_names
    tags               = module.vpc.tags
  }
}
