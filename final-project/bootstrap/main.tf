terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "s3_backend" {
  source = "../modules/s3-backend"

  bucket_name         = "kate2603-final-tf-state"
  dynamodb_table_name = "kate2603-final-tf-locks"
  tags = {
    Project     = "final-project"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

output "bucket_name" {
  value = module.s3_backend.bucket_name
}

output "dynamodb_table_name" {
  value = module.s3_backend.dynamodb_table_name
}
