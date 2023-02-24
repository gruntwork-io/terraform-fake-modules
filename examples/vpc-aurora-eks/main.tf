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

variable "namespace" {
  description = "Namespace in which environments are deployed."
  default     = "fake-module"
  type        = string
}

variable "environment" {
  description = "Environment in which resources are deployed."
  default     = "development"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  type        = string
  default     = "10.0.0.0/16"

}

variable "subnet_count" {
  description = "Number of subnets created in the VPC."
  type        = number
  default     = 4
}

module "vpc" {
  source = "./../../modules/aws/vpc"

  namespace   = var.namespace
  environment = var.environment

  cidr_block   = var.vpc_cidr_block
  subnet_count = var.subnet_count

  providers = {
    aws = aws.this
  }
}

module "eks" {
  source = "./../../modules/aws/eks"

  namespace   = var.namespace
  environment = var.environment

  vpc_id = module.vpc.id

  providers = {
    aws = aws.this
  }
}

module "aurora" {
  source = "./../../modules/aws/aurora"

  namespace   = var.namespace
  environment = var.environment

  vpc_id = module.vpc.id

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
  }
}

output "eks" {
  value = {
    name                = module.eks.name,
    arn                 = module.eks.arn,
    api_server_endpoint = module.eks.api_server_endpoint
  }
}

output "aurora" {
  value = {
    name            = module.aurora.name,
    arn             = module.aurora.arn,
    writer_endpoint = module.aurora.writer_endpoint
    reader_endpoint = module.aurora.reader_endpoint
    port            = module.aurora.port
    engine          = { name = module.aurora.engine_name, version = module.aurora.engine_version }
  }
}
