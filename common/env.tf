data "terraform_remote_state" "global" {
  backend = "local"

  config {
    path = "${var.global_remote_state}"
  }
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
  aws_region          = "${data.terraform_remote_state.global.env_region[var.env_name]}"
}

output "aws_region" {
  value = "${data.terraform_remote_state.global.env_region[var.env_name]}"
}

output "az_count" {
  value = "${var.az_count}"
}
