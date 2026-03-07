module "ecr" {
  source = "./modules/ecr"

  repository_name = var.ecr_repository_name
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name

  vpc_id          = data.aws_vpc.default.id
  public_subnets  = data.aws_subnets.default.ids
  private_subnets = data.aws_subnets.default.ids

  instance_types = var.instance_types
  desired_size   = var.desired_size
  min_size       = var.min_size
  max_size       = var.max_size
}

module "jenkins" {
  source = "./modules/jenkins"

  jenkins_namespace  = var.jenkins_namespace
  ecr_repository_url = module.ecr.repository_url

  depends_on = [module.eks]
}

module "argo_cd" {
  source = "./modules/argo_cd"

  argocd_namespace   = var.argocd_namespace
  gitops_repo_url    = var.gitops_repo_url
  gitops_repo_branch = var.gitops_repo_branch
  gitops_repo_path   = var.gitops_repo_path

  depends_on = [module.eks]
}