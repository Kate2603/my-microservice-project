variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "lesson-7"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_state_bucket" {
  description = "S3 bucket with lesson-5 terraform state"
  type        = string
  default     = "kate-tf-state-bucket"
}

variable "vpc_state_key" {
  description = "State key for lesson-5"
  type        = string
  default     = "lesson-5/terraform.tfstate"
}

variable "vpc_state_region" {
  description = "Region for remote state"
  type        = string
  default     = "eu-central-1"
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "lesson-7-django-app"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "lesson-7-eks-cluster"
}

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
  default     = "lesson-7-node-group"
}

variable "instance_types" {
  description = "EC2 instance types for EKS workers"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Desired node count"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum node count"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum node count"
  type        = number
  default     = 3
}