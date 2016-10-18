module "env" {
  source              = "../module/env"
  global_remote_state = "${var.global_remote_state}"
  env_name            = "${var.env_name}"
  env_cidr            = "${data.terraform_remote_state.global.env_cidr[var.env_name]}"
  az_count            = "${var.az_count}"
  nat_nets            = ["${data.terraform_remote_state.global.sys_nets["nat"]}"]
  common_nets         = ["${data.terraform_remote_state.global.sys_nets["common"]}"]
}
