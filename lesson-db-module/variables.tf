variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "lesson-db-module"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "Existing VPC ID where DB will be deployed"
  type        = string
  default     = "vpc-0123456789abcdef0"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for DB subnet group"
  type        = list(string)
  default = [
    "subnet-0123456789abcdef0",
    "subnet-0fedcba9876543210"
  ]
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the DB"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}