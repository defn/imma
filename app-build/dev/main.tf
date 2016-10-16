data "consul_keys" "app" {
  key {
    name    = "packer_nets"
    path    = "app/${var.app_name}/packer/nets"
    default = "108 109 110"
  }
  key {
    name    = "blocks_nets"
    path    = "app/${var.app_name}/blocks/nets"
    default = "123 124 125"
  }
}

module "app" {
  source              = "../../fogg/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.dev_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}

module "packer" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.dev_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "packer"
  service_nets        = ["${split(" ",data.consul_keys.app.var.packer_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}

module "blocks" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.dev_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "blocks"
  service_nets        = ["${split(" ",data.consul_keys.app.var.blocks_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
  want_fs             = "1"
}
