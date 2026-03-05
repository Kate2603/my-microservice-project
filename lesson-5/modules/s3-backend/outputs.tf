output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.tf_state.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.tf_state.arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.tf_locks.name
}
