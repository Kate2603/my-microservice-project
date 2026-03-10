module "vpc" {
  source = "./modules/vpc"

  vpc_name           = var.vpc_name
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  tags               = var.tags
}

module "ecr" {
  source = "./modules/ecr"

  ecr_name = var.ecr_repository_name
  tags     = var.tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  node_group_name = var.node_group_name
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
  instance_types  = var.instance_types
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
  tags            = var.tags
}

module "rds" {
  source = "./modules/rds"

  project_name            = var.project_name
  vpc_id                  = module.vpc.vpc_id
  private_subnets         = module.vpc.private_subnet_ids
  allowed_security_groups = [module.eks.cluster_security_group_id]
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  db_engine               = var.db_engine
  db_instance_class       = var.db_instance_class
  allocated_storage       = var.allocated_storage
  use_aurora              = var.use_aurora
  aurora_engine           = var.aurora_engine
  aurora_instance_class   = var.aurora_instance_class
  tags                    = var.tags
}

module "jenkins" {
  source = "./modules/jenkins"

  jenkins_namespace  = var.jenkins_namespace
  ecr_repository_url = module.ecr.repository_url

  depends_on = [module.eks]
}

module "argocd" {
  source = "./modules/argocd"

  argocd_namespace   = var.argocd_namespace
  gitops_repo_url    = var.gitops_repo_url
  gitops_repo_branch = var.gitops_repo_branch
  gitops_repo_path   = var.gitops_repo_path

  depends_on = [module.eks]
}

module "monitoring" {
  source = "./modules/monitoring"

  namespace = var.monitoring_namespace

  depends_on = [module.eks]
}