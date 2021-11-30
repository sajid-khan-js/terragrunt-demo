terraform {
  backend "s3" {
    key    = "eks/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = "my-cluster"
  # Must get this after you apply ../vpc first
  vpc_id          = "vpc-3334556abcdef"     
  # Must get this after you apply ../vpc first                                  
  subnets         = ["subnet-bacde012", "subnet-cbde012a", "subnet-gfhi345a"]

  worker_groups = [
    {
      instance_type = var.instance_type
      asg_max_size  = var.instance_max
    }
  ]
  
  cluster_tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
