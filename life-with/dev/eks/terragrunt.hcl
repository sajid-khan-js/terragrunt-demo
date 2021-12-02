# Since we are interpolating some of these values into map variables for this
# particular module, we need to grab a local copy of the values in env.hcl. You
# don't need to do this if values in your env.hcl or root terragrunt.hcl match
# the module's variable name and type
locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  current_env      = local.environment_vars.locals.env
}

# This will pull in values and config from the root terragrunt.hcl
include {
  path = find_in_parent_folders()
}

# The actual module we want to deploy
terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-eks"
}

# A dependency block will ensure that this module does not get deployed until
# the dependency is finished and allows us to reference outputs
dependency "vpc_deployment" {
  config_path = "../vpc/"
  # These are necessary for plans, how can terragrunt generate a plan here when
  # the dependent infra doesn't exist yet? The answer is mock outputs
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

  # You can still set module inputs like so, useful for trying out new config in
  # different environments. Note: if the below var cluster_version was
  # already set in the root terragrunt.hcl or env.hcl, then the below setting
  # would still override anything in there
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
