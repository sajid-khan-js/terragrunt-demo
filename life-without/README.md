# Life without terragrunt

> The biggest issue with scaling vanilla terraform deployments is that your
> workflow suffers, and you start structuring your infrastructure code around
> these limitations rather than your actual architecture

:memo: After reading this you may think "a simple Bash/Python script would solve
these issues", you're right, it would, but what solves the issues with your
buggy script, especially as it gets more complex as you scale?
[Terragrunt](https://github.com/gruntwork-io/terragrunt) has come across, and
solved issues your script is yet to encouter. The same reason you use terraform
in most cases to interact with cloud vendor APIs, is the same reason you should
use a well established tool (6+ years) to scale terraform deployments. Simply
put, if you find yourself in this problem space, why re-invent the wheel?

## Symlinks

Symlinks are a bit crude, but get you a long way into keeping things DRY with
  vanilla terraform. Unfortunately, there are still some issues:

- A single shared `terraform.tfvars` won't scale, you'll eventually have
  variable name clashes, or just too much going on in one file. You could break
  things up with multiple `*.tfvars` files, but then would have to remember to
  invoke them everytime you ran `terraform plan/apply` i.e. `terraform plan
  -var-file=myfile.tfvars -var-file=mysecondfile.tfvars`
- This is also the case for the "partial" remote state configuration (the remote
  state block does not support variables), you have to remember to run
  `terraform init -backend-config=backend.tfvars` or have a hardcoded remote
  config in every deployment, pick your poison.
- You need to remember to set symlinks up (i.e. `ln -s ../terraform.tfvars
  terraform.tfvars`) everytime you create a new deployment
- There's still multiple sources of truth, e.g. the region is defined in two
  places (`backend.tfvars` and `terraform.tfvars`), and there's still necessary
  boilerplate for each deployment (e.g. `outputs.tf`). You could go super
  aggressive with symlinks and centralise other things e.g. the provider block,
  outputs.tf. Although we want environments to be uniform (à la the 12 Factor
  App), I think it's prudent to have some flexibility available in each
  environment, otherwise, you might be nudging people towards manual changes in
  the console when experimenting, because your infra as code setup is too
  restrictive

## State

- Even with the partial state configuration, you still need to remember to
  update the "key" (i.e. the path to your statefile in your bucket). What
  happens if you copy and paste the VPC config to your EKS folder (to use it as
  a starting point), but forget to update that key, thus overwriting your VPC
  statefile? `terraform import` will help you salvage that situation, but any
  workflow/process that relies on a human to remember things is doomed.

## Dependencies

You need to run your terraform deployments in a particular order, that might be
obvious in this example ("of course you need a VPC for your EKS cluster, duh"),
but that's not always clear, especially when you are deploying custom terraform
modules that deploy a wide variety of infrastructure. Imagine you're about to
deploy an app specific module (sets up some Lambdas and an S3 bucket), your
module is expecting a certain central custom IAM role to exist (that role is
setup by another terraform module), even if you wrote all those terraform
modules yourself, I guarantee a few months down the line you'd forget about that
dependency.

Another issue is that you must remember to complete the EKS modules inputs after
you've deployed the VPC i.e. you need the VPC ID and subnet IDs. This is a
suboptimal workflow, it nudges people towards running terraform locally rather
than through a pipeline (and thus a pull-request process), and is brittle: what
if you key in the public subnet IDs by mistake when creating your EKS cluster?

## References

- <https://github.com/hashicorp/terraform/issues/13022>
- <https://www.terraform.io/docs/language/settings/backends/configuration.html#partial-configuration>
- <https://www.monterail.com/blog/chicken-or-egg-terraforms-remote-backend>
- <https://medium.com/datamindedbe/avoiding-copy-paste-in-terraform-two-approaches-for-multi-environment-infra-as-code-setups-b26b7251cb11>
- <https://12factor.net/dev-prod-parity>
- <https://www.terraform.io/docs/cli/import/index.html>
