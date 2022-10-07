terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket//.?ref=v3.3.0"
}
include {
  path = find_in_parent_folders()
}

locals {
  file        = "variables/${get_env("TF_WORKSPACE")}.yml"
  common_vars = yamldecode(file(find_in_parent_folders(local.file)))
}

inputs = {
  bucket = local.common_vars.bucket
  acl    = "private"
}




