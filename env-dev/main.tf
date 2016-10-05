module "env" {
  source              = "../fogg/env"
  global_remote_state = "${var.global_remote_state}"
  env_name            = "${var.env_name}"
  env_cidr            = "${var.env_cidr}"
}
