variable admin_remote_state {}

variable www_nets {
  default = []
}

variable db_nets {
  default = []
}

module "app" {
  source              = "../../fogg/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}

module "www" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "www"
  service_nets        = ["${var.www_nets}"]
  security_groups     = ["${module.app.app_sg}"]
}

module "db" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "db"
  service_nets        = ["${var.db_nets}"]
  security_groups     = ["${module.app.app_sg}"]
}
