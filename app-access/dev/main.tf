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
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}

module "openvpn" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
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
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "bastion"
  service_nets        = ["${split(" ",data.consul_keys.app.var.bastion_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  public_network      = "1"
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}

resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${module.bastion.service_sg}"
}

resource "aws_security_group_rule" "allow_bastion_ping" {
  type                     = "ingress"
  from_port                = 9
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = "${module.bastion.service_sg}"
  security_group_id        = "${data.terraform_remote_state.env.sg_env}"
}

resource "aws_security_group_rule" "allow_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${module.bastion.service_sg}"
  security_group_id        = "${data.terraform_remote_state.env.sg_env}"
}
