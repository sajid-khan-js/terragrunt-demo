locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  current_env      = local.environment_vars.locals.env
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"
}


inputs = {
  name = "myvpc"

  enable_nat_gateway = false
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = local.current_env
  }
}
