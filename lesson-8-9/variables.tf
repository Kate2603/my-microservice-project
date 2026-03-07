variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "lesson-8-9"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "lesson-8-9-django"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "lesson-8-9-eks-cluster"
}

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
  default     = "lesson-8-9-node-group"
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
  default     = 1
}

variable "max_size" {
  description = "Maximum node count"
  type        = number
  default     = 2
}

variable "jenkins_namespace" {
  description = "Namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "argocd_namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "gitops_repo_url" {
  description = "GitOps repository URL"
  type        = string
  default     = "https://github.com/Kate2603/django-gitops.git"
}

variable "gitops_repo_branch" {
  description = "GitOps repository branch"
  type        = string
  default     = "main"
}

variable "gitops_repo_path" {
  description = "Path to Helm chart inside GitOps repo"
  type        = string
  default     = "charts/django-app"
}