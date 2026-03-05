output "backend_s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = module.s3_backend.s3_bucket_name
}

output "backend_s3_bucket_arn" {
  description = "S3 bucket ARN for Terraform state"
  value       = module.s3_backend.s3_bucket_arn
}

output "backend_dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}
