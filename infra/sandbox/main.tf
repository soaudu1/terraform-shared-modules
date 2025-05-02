terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
}

# Global variables
locals {
  aws_region = "us-east-1"
  tags = {
    Environment = "sandbox"
    Project     = "eks-sandbox"
  }
}

# ----------------------------------------------------
# 1. VPC Module
# ----------------------------------------------------
module "vpc" {
  source = "./../../modules/vpc/"

  aws_region          = local.aws_region
  name                = "sandbox"
  cidr_block          = "10.0.0.0/16"
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
  tags                = local.tags
}

# ----------------------------------------------------
# 2. IAM Module
# ----------------------------------------------------
module "iam" {
  source = "./../../modules/iam/"

  aws_region            = local.aws_region
  name                  = "sandbox"
  node_group_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
  codebuild_policy_arns = []  # No CodeBuild now
  tags                  = local.tags
}

# ----------------------------------------------------
# 3. ECR Module
# ----------------------------------------------------
module "ecr" {
  source = "./../../modules/ecr/"

  aws_region            = local.aws_region
  name                  = "wep-admin-service"
  image_tag_mutability  = "MUTABLE"
  scan_on_push          = true
  tags                  = local.tags
}

# ----------------------------------------------------
# 4. EKS Module
# ----------------------------------------------------
module "eks" {
  source = "./../../modules/eks/"

  aws_region            = local.aws_region
  name                  = "sandbox"
  cluster_role_arn      = module.iam.eks_cluster_role_arn
  node_group_role_arn   = module.iam.eks_node_group_role_arn
  subnet_ids            = module.vpc.public_subnet_ids

  kubernetes_version      = "1.29"
  node_group_desired_size = 2
  node_group_min_size     = 1
  node_group_max_size     = 3
  instance_types          = ["t3.medium"]

  dependency = module.iam

  tags = local.tags
}

module "codeartifact" {
  source = "./../../modules/codeartifact/"

  domain_name       = "sandbox-domain"
  repository_name   = "sandbox-repo"
  description       = "Private artifact store for sandbox environment"
  external_connections = ["public:npmjs"]

  tags = {
    Environment = "sandbox"
    Project     = "eks-sandbox"
  }
}

# ----------------------------------------------------
# 5. ArgoCD Module
# ----------------------------------------------------
module "argocd" {
  source = "./../../modules/argocd/"

  cluster_name = module.eks.cluster_name

  depends_on = [module.eks]
}
