locals {
  cluster_name = "my-eks-cluster"
}

module "vpc" {
  source = "git::https://git@github.com/reactiveops/terraform-vpc.git"

  aws_region = "ap-south-1"
  az_count   = 2
  aws_azs    = "ap-south-1a, ap-south-1b"

  global_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

module "eks" {
  source       = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git"
  cluster_name = local.cluster_name
  vpc_id       = module.vpc.aws_vpc_id
  subnets      = module.vpc.aws_subnet_private_prod_ids

  node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 3
      min_capaicty     = 3

      instance_type = "t2.small"
    }
  }

  manage_aws_auth = false
}

