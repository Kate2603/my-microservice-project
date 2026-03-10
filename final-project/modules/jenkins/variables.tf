variable "jenkins_namespace" {
  type        = string
  description = "Namespace for Jenkins"
  default     = "jenkins"
}

variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL"
}
