aws_region          = "us-west-2"
project_name        = "lesson-8-9"
environment         = "dev"
ecr_repository_name = "lesson-8-9-django"

cluster_name    = "lesson-8-9-eks-cluster"
node_group_name = "lesson-8-9-node-group"
instance_types  = ["t3.medium"]
desired_size    = 2
min_size        = 1
max_size        = 2

jenkins_namespace = "jenkins"
argocd_namespace  = "argocd"

gitops_repo_url    = "https://github.com/Kate2603/django-gitops.git"
gitops_repo_branch = "main"
gitops_repo_path   = "charts/django-app"