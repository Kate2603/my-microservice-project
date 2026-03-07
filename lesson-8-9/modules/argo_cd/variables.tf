variable "argocd_namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "gitops_repo_url" {
  description = "GitOps repository URL"
  type        = string
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