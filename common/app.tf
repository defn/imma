provider "aws" {
  region = "${data.terraform_remote_state.env.aws_region}"
}

data "terraform_remote_state" "global" {
  backend = "local"

  config {
    path = "../../.terraform/terraform.tfstate"
  }
}

data "terraform_remote_state" "env" {
  backend = "local"

  config {
    path = "../.terraform/terraform.tfstate"
  }
}

module "app" {
  source              = "../../../../module/app"
  global_remote_state = "${data.terraform_remote_state.global.config["path"]}"
  env_remote_state    = "${data.terraform_remote_state.env.config["path"]}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
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
