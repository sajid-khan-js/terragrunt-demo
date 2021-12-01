terraform {
  backend "s3" {
    bucket         = "mydevterraformstatebucket"
    key            = "dev/vpc/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}
