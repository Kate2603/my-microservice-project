terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  aws_region = "us-west-2"

  # Реальні назви (можеш змінити, якщо буде конфлікт у S3 bucket name)
  state_bucket_name = "kateryna-velychko-lesson-5-terraform-state-usw2"
  lock_table_name   = "terraform-locks"

  vpc_name = "lesson-5-vpc"

  vpc_cidr_block = "10.0.0.0/16"

  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  ecr_name     = "lesson-5-ecr"
  scan_on_push = true

  common_tags = {
    Project   = "lesson-5"
    ManagedBy = "Terraform"
    Owner     = "Kateryna-Velychko"
  }
}

# 1) S3 + DynamoDB для backend (state + locking)
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = local.state_bucket_name
  table_name  = local.lock_table_name
  tags        = local.common_tags
}

# 2) VPC (3 public + 3 private), IGW, NAT GW, routing
module "vpc" {
  source             = "./modules/vpc"
  vpc_name           = local.vpc_name
  vpc_cidr_block     = local.vpc_cidr_block
  public_subnets     = local.public_subnets
  private_subnets    = local.private_subnets
  availability_zones = local.availability_zones
  tags               = local.common_tags
}

# 3) ECR repository
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = local.ecr_name
  scan_on_push = local.scan_on_push
  tags         = local.common_tags
}
