module "app" {
  source              = "../../fogg/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}

module "openvpn" {
  service_name        = "openvpn"
  service_nets        = ["${data.terraform_remote_state.global.service_nets["openvpn"]}"]
  public_network      = "1"
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  security_groups     = ["${module.app.app_sg}"]
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}

module "bastion" {
  service_name        = "bastion"
  service_nets        = ["${data.terraform_remote_state.global.service_nets["bastion"]}"]
  public_network      = "1"
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  security_groups     = ["${module.app.app_sg}"]
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
