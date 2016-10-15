data "consul_keys" "app" {
  key {
    name    = "www_nets"
    path    = "app/${var.app_name}/www/nets"
    default = "102 103 107"
  }

  key {
    name    = "db_nets"
    path    = "app/${var.app_name}/db/nets"
    default = "104 105 106"
  }
}

module "app" {
  source              = "../../fogg/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.dev_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}

module "www" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.dev_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "www"
  service_nets        = ["${split(" ",data.consul_keys.app.var.www_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  public_network      = "1"
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
  want_fs             = "1"
}

module "db" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.dev_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "db"
  service_nets        = ["${split(" ",data.consul_keys.app.var.db_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
}
