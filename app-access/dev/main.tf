data "consul_keys" "app" {
  key {
    name    = "openvpn_nets"
    path    = "app/${var.app_name}/openvpn/nets"
    default = "99 100 101"
  }

  key {
    name    = "bastion_nets"
    path    = "app/${var.app_name}/bastion/nets"
    default = "102 103 104"
  }
}

module "app" {
  source              = "../../fogg/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.dev_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}

module "openvpn" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.dev_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "openvpn"
  service_nets        = ["${split(" ",data.consul_keys.app.var.openvpn_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  public_network      = "1"
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}

module "bastion" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.dev_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "bastion"
  service_nets        = ["${split(" ",data.consul_keys.app.var.bastion_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  public_network      = "1"
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}
