locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  current_env      = local.environment_vars.locals.env

}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-eks"
}
dependency "vpc_deployment" {
  config_path = "../vpc/"
  mock_outputs = {
    vpc = {
      vpc_id = "stub-vpc-id"
      private_subnets = [
        "stub-subnet-1",
        "stub-subnet-2",
        "stub-subnet-3",
      ]
    }
  }
}


inputs = {

  cluster_version = "1.21"
  cluster_name    = "my-cluster"

  vpc_id  = dependency.vpc_deployment.outputs.vpc.vpc_id
  subnets = dependency.vpc_deployment.outputs.vpc.private_subnets

  worker_groups = [
    {
      instance_type = local.environment_vars.locals.instance_type
      asg_max_size  = local.environment_vars.locals.instance_max
    }
  ]
  cluster_tags = {
    Terraform   = "true"
    Environment = local.current_env
  }
}
