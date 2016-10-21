variable "aws_region" {}

output "aws_region" {
  value = "${var.aws_region}"
}

provider "aws" {
  region = "${var.aws_region}"
}

data "aws_region" "current" {
  current = true
}

module "env" {
  source              = "../../module/env"
  global_remote_state = "${var.global_remote_state}"
  env_name            = "${var.env_name}"
  env_cidr            = "${data.terraform_remote_state.global.env_cidr[var.env_name]}"
  az_count            = "${var.az_count}"
  nat_count           = "${var.nat_count}"
  nat_nets            = ["${data.terraform_remote_state.global.sys_nets["nat"]}"]
  common_nets         = ["${data.terraform_remote_state.global.sys_nets["common"]}"]
  want_fs             = "${var.want_fs}"
}
