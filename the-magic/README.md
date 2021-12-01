# What does terragrunt actually do?

:warning: This isn't strictly the exact process that terragrunt follows. What's
important is that you understand what each piece of terragrunt config means in
relation to vanilla terraform.

## The magic

So what happens when you run `terragrunt plan/apply` in a deployment directory
e.g. `dev/vpc`?

The below will walk you thorough the steps, and link to relevant files in a
folder ([vpc](./vpc)) where I've manually carried out the steps, so you can see
what the end result looks like.

1. In a staging directory (`.terragrunt-cache`) terragrunt pulls down the module
   source either from git or a relative path. In this example you can see it's
   just git cloned: <https://github.com/terraform-aws-modules/terraform-aws-vpc>
1. Creates a [backend.tf](./vpc/backend.tf) based on your remote state config
   defined in your root terragrunt.hcl, and figures out the relative path and
   uses that as the key for your state file
1. Creates a [provider.tf](./vpc/provider.tf) based on your provider config in
   your root terragrunt.hcl
1. Creates a [terraform.tfvars](./vpc/terraform.tfvars) based on all the values
   declared in your root terragrunt.hcl, env.hcl, and "inputs" specified in the
   terragrunt.hcl deployment file
1. Runs `terraform init` for you
1. Runs `terraform plan/apply` (or whatever other terragrunt command you invoked
   e.g. `terragrunt destroy`)
