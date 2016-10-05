variable "dev_remote_state" {}

variable "sandbox_remote_state" {}

module "env" {
  source              = "../fogg/env"
  global_remote_state = "${var.global_remote_state}"
  env_name            = "${var.env_name}"
  env_cidr            = "${var.env_cidr}"
  az_count            = "${var.az_count}"
  az_names            = ["${var.az_names}"]
  nat_bits            = "${var.nat_bits}"
  nat_nets            = ["${var.nat_nets}"]
}
