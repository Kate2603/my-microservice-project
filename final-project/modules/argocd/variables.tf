variable "argocd_namespace" {
  type        = string
  description = "Namespace for Argo CD"
  default     = "argocd"
}

variable "gitops_repo_url" {
  type        = string
  description = "GitOps repository URL"
}

variable "gitops_repo_branch" {
  type        = string
  description = "GitOps repository branch"
  default     = "main"
}

variable "gitops_repo_path" {
  type        = string
  description = "Path to Helm chart in GitOps repo"
  default     = "charts/django-app"
}
