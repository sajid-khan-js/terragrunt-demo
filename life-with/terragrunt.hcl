# Note: the output of this file will change based on where it get's called from
# e.g. dev/eks would generate different values when compared to prd/eks.
locals {
  region = "eu-west-1"
  # Pull in environment level values
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  # Pull the environment name out, to make it more readable when used below
  current_env = local.environment_vars.locals.env
}

remote_state {
  backend = "s3"
  config = {

    # Generate a backend config based on the calling environment i.e. which
    # environment folder the deployment lives in
    bucket         = "my${local.current_env}terraformstatebucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}

# This needs to be done so terragrunt will auto populate any modules that have
# matching variable names e.g. if a module has a variable called "azs" or
# "region" or "cidr" terragrunt will set those variables values based on what's
# here automatically. Note: you can override the variable value within the
# deployment terragrunt.hcl aswell.
inputs = merge(
  local.environment_vars.locals,
  {
    region = local.region
    azs    = ["${local.region}a", "${local.region}b", "${local.region}c"]
  },
)
