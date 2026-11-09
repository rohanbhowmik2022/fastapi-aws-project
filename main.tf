terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-2"
}

# 1. Create a baseline VPC
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "~> 5.0"

    name = "devops-vpc"
    cidr = "10.0.0.0/16"

    azs = ["ap-south-2a", "ap-south-2b"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.11.0/24","10.0.12.0/24"]
}

# 2. Create managed Kubernetes Service
module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 20.0"

    cluster_name = "devops-cluster"
    cluster_version = "1.31"

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets

    eks_managed_node_groups = {
        general = {
            desired_size = 2
            min_size = 1
            max_size = 3

            instance_types = ["t3.medium"]
        }
    }
}