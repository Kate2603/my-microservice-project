variable "jenkins_namespace" {
  description = "Namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}