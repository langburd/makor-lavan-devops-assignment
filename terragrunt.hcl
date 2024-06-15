terraform {
  extra_arguments "common" {
    commands = get_terraform_commands_that_need_vars()
  }
  extra_arguments "non-interactive" {
    commands = [
      "apply",
      "destroy"
    ]
    arguments = [
      "-auto-approve",
      "-compact-warnings"
    ]
  }
}

locals {
  common_vars   = yamldecode(file(find_in_parent_folders("vars.yaml")))
  environment   = basename(dirname(get_terragrunt_dir()))
  env_vars      = yamldecode(file(find_in_parent_folders("env.yaml")))
  resource      = basename(get_terragrunt_dir())
  resource_vars = yamldecode(file("${get_terragrunt_dir()}/tf_source_vars.yaml"))
}

remote_state {
  backend = "s3"
  config = {
    bucket                   = "mend-playground-avi"
    key                      = "${path_relative_to_include()}/terraform.tfstate"
    region                   = local.common_vars.common["default_region"]
    encrypt                  = true
    skip_bucket_ssencryption = true
    dynamodb_table           = "mend-playground-avi"
    s3_bucket_tags = {
      "Department" = "DevOps"
      // "GitRepository" = "https://github.com/langburd/makor-lavan-devops-assignment"
      "Owner"     = "Avi Langburd"
      "Temp"      = "True"
      "Terraform" = "True"
    }
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

skip = true
