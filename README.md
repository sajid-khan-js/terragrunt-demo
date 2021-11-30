# terragrunt-demo

> A demo on how terragrunt makes your life easier when using terraform at scale

## Description

- [life-without](./life-without) - Showcasing some of the paint points when
  working with terraform at scale. I've included typical workarounds.

- [life-with](./life-with) - Showcasing terragrunt and how it makes using
  terraform at scale much easier.

- [the-magic](./the-magic) - What does terragrunt actually do when you run
  `terragunt plan/apply`? Find out here.

In both examples, I am trying to deploy a VPC and an EKS cluster to multiple
environments (dev and prd), I'm using these respective community terraform
modules [1](https://github.com/terraform-aws-modules/terraform-aws-vpc),
[2](https://github.com/terraform-aws-modules/terraform-aws-eks).

:warning: Although I'm familiar with these modules, I've not actually run any of
this terraform/terragrunt past a `terraform plan`

## References

- Although this repo shows you the value of terragrunt, there is a better way to
  structure your terragrunt repo (especially if you are multi-region), have a
  look a
  [here](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example)
