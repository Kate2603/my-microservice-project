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