remote_state {
  backend = "s3"
  config = {
    bucket  = "tf-state-bucket-${get_aws_account_id()}-us-east-1"
    profile = get_env("AWS_PROFILE")
    key     = "${path_relative_to_include()}.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_version = ">= 1.2.6"

  backend "s3" {}
}
EOF
}
