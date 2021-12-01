# terragrunt-demo

> A demo on how terragrunt makes your life easier when using terraform at scale

## What is terragrunt?

### TL;DR

Terragrunt is a thin wrapper around terraform that…blah…blah...

Essentially,

`terragrunt plan > *magic happens* > runs terraform plan for you`

`terragrunt apply > *magic happens* > runs terraform apply for you`

You are still running terraform in the background, so you still write normal
terraform, but when you usually execute your terraform (i.e. when you run
terraform plan/apply), you now use terragrunt todo that for you instead.

More info [here](https://terragrunt.gruntwork.io)

### Inheritance and context

Take a look at the below directory structure:

```text
├── dev
│   ├── env.hcl
│   ├── eks
│   │   └── terragrunt.hcl
│   └── vpc
│       └── terragrunt.hcl
├── prd
│   ├── env.hcl
│   ├── eks
│   │   └── terragrunt.hcl
│   └── vpc
│       └── terragrunt.hcl
└── terragrunt.hcl
```

Wouldn't it be great when you were in `dev/vpc` and ran an infra command it
would just figure stuff out like what environment it was in and act accordingly?

Keeping this in mind: `root terragrunt.hcl > dev/env.hcl > vpc/terragrunt.hcl`:
When you run `terragrunt plan` in `dev/vpc`, which executes the config in
`dev/vpc/terragrunt.hcl`, it inherits what came before it i.e. `env.hcl`, and
the root `terragrunt.hcl`. It can also make decisions based on that context,
e.g. for dev my state bucket is X, my AWS role to assume is Y, and my deployment
config for that module is Z

For me that's terragrunt's biggest feature, it allows you to create intuitive
infrastructure code structures that just work. Imagine telling a junior engineer
to update the EKS cluster in dev, it's obvious where they need to go and if
you've configured terragrunt correctly, `terragrunt plan` will just work.

You might be thinking "You're really overselling a directory structure", but
I've seen, and created myself, plenty of vanilla terraform code structures that
at the very least were a pain to work with, or where you could cause chaos in
prd because you forget to switch context.

Imagine you had to remember todo steps A, B, C before running `terraform plan`
in dev, and then steps X, Y, Z before running `terraform plan` in prd. That
get's annoying but also can be catastrophic, for example I get myself setup for
prd, get distracted, think I'm actually setup for dev, and cause chaos in prd
inadvertently.

Terragrunt let's you declaratively set those steps as code, which gives you
increased productivity when working across environments, but also safety.

## Structure

- [life-without](./life-without) - Showcasing some of the paint points when
  working with terraform at scale. I've included typical workarounds.

- [life-with](./life-with) - Showcasing terragrunt and how it makes using
  terraform at scale much easier.

- [the-magic](./the-magic) - What does terragrunt actually do when you run
  `terragunt plan/apply`? Find out here.

In the above examples, I am trying to deploy a VPC and an EKS cluster to multiple
environments (dev and prd), I'm using these respective community terraform
modules [1](https://github.com/terraform-aws-modules/terraform-aws-vpc),
[2](https://github.com/terraform-aws-modules/terraform-aws-eks).

:warning: Although I'm familiar with these modules, I've not actually run any of
this terraform/terragrunt past a `terraform/terragrunt plan` so expect some
turbulence if you want to actually deploy this config in an AWS account!

## Setup

If you want to follow along in your own AWS account:

- Be authenticated with the the AWS CLI, lots of options here but if you're not
  sure follow [this
  guide](https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html)

- Create the following in `eu-west-1`:
  - Create two buckets, `mydevterraformstatebucket`,
    `myprdterraformstatebucket`. If those names are taken you'll have to update
    any references to those bucket names in the codebase.
  - Create a DynamoDB table called `my-lock-table`, set the Partition key to
    `LockID`

## References

- Although this repo shows you the value of terragrunt, there is a better way to
  structure your terragrunt repo (especially if you are multi-account,
  multi-region), have a look a
  [here](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example)
- Quick start guide:
  <https://terragrunt.gruntwork.io/docs/getting-started/quick-start/>
- GitHub repo: <https://github.com/gruntwork-io/terragrunt>
