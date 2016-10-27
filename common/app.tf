provider "aws" {
  region = "${data.terraform_remote_state.env.aws_region}"
}

module "app" {
  source              = "../../module/app"
  global_remote_state = "${data.terraform_remote_state.env.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}

data "terraform_remote_state" "global" {
  backend = "local"

  config {
    path = "${data.terraform_remote_state.env.global_remote_state}"
  }
}

data "terraform_remote_state" "env" {
  backend = "local"

  config {
    path = "${var.env_remote_state}"
  }
}

variable public_network {
  default = {}
}

variable want_fs {
  default = {}
}

variable instance_type {
  default = {}
}

output global_remote_state {
  value = "${data.terraform_remote_state.env.global_remote_state}"
}

output env_remote_state {
  value = "${var.env_remote_state}"
}
