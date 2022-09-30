terraform {
  source = "git@github.com:gigops/gigops-terraforming-template-infra.git//modules/bastion/?ref=module_bastion_0.0.1a"
}

include {
  path = find_in_parent_folders()
}

locals {
  file        = "variables/${get_env("TF_WORKSPACE")}.yml"
  common_vars = yamldecode(file(find_in_parent_folders(local.file)))
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    vpc_id         = "xxxxxxxx"
    public_subnets = ["xxxxxxxx", "yyyyyyy"]
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["workspace", "init", "plan"]
}

inputs = {
  project          = get_env("TF_WORKSPACE")
  vpc_id           = dependency.network.outputs.vpc_id
  subnet_id_public = dependency.network.outputs.public_subnets[0]
}
