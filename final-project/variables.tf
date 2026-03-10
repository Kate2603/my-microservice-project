variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "final-project"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "final-vpc"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "final-django-app"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "final-eks-cluster"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.29"
}

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
  default     = "final-node-group"
}

variable "instance_types" {
  description = "Worker instance types"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Desired node group size"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum node group size"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum node group size"
  type        = number
  default     = 2
}

variable "jenkins_namespace" {
  description = "Jenkins namespace"
  type        = string
  default     = "jenkins"
}

variable "argocd_namespace" {
  description = "Argo CD namespace"
  type        = string
  default     = "argocd"
}

variable "monitoring_namespace" {
  description = "Monitoring namespace"
  type        = string
  default     = "monitoring"
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
  description = "Path to Helm chart in GitOps repo"
  type        = string
  default     = "charts/django-app"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
  default     = "ChangeMe123456!"
}

variable "db_engine" {
  description = "Database engine for RDS instance"
  type        = string
  default     = "postgres"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "use_aurora" {
  description = "Create Aurora cluster instead of classic RDS"
  type        = bool
  default     = false
}

variable "aurora_engine" {
  description = "Aurora engine"
  type        = string
  default     = "aurora-postgresql"
}

variable "aurora_instance_class" {
  description = "Aurora instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project     = "final-project"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
