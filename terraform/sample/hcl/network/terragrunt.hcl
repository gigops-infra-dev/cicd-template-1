terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc.git//.?ref=v3.14.4"
}
include {
  path = find_in_parent_folders()
}

locals {
  file        = "variables/${get_env("TF_WORKSPACE")}.yml"
  common_vars = yamldecode(file(find_in_parent_folders(local.file)))
}

inputs = {
  name = "${get_env("TF_WORKSPACE")}-vpc"
  cidr = local.common_vars.cidr

  azs            = local.common_vars.azs
  public_subnets = local.common_vars.public_subnets

  create_egress_only_igw          = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  enable_flow_log                      = false
  create_flow_log_cloudwatch_iam_role  = false
  create_flow_log_cloudwatch_log_group = false

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "47a"
  }
}
