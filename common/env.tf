provider "aws" {
  region = "${data.terraform_remote_state.global.env_region[var.env_name]}"
}

data "terraform_remote_state" "global" {
  backend = "local"

  config {
    path = "../.terraform/terraform.tfstate"
  }
}

module "env" {
  source              = "../../../module/env"
  global_remote_state = "${data.terraform_remote_state.global.config["path"]}"
  env_name            = "${var.env_name}"
  az_count            = "${var.az_count}"
  env_cidr            = "${data.terraform_remote_state.global.env_cidr[var.env_name]}"
  nat_nets            = ["${data.terraform_remote_state.global.sys_nets["nat"]}"]
  common_nets         = ["${data.terraform_remote_state.global.sys_nets["common"]}"]
  aws_region          = "${data.terraform_remote_state.global.env_region[var.env_name]}"
  nat_count           = "${var.nat_count}"
  want_fs             = "${var.want_fs}"
  want_nat            = "${var.want_nat}"
}

output "aws_region" {
  value = "${data.terraform_remote_state.global.env_region[var.env_name]}"
}

output "env_region" {
  value = "${data.terraform_remote_state.global.env_region}"
}
