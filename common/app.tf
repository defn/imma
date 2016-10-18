variable global_remote_state {
  default = ".global.tfstate"
}

variable env_remote_state {
  default = ".env.tfstate"
}

data "terraform_remote_state" "env" {
  backend = "local"

  config {
    path = "${var.env_remote_state}"
  }
}

module "app" {
  source              = "../../module/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}
