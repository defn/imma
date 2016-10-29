resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${module.service.service_sg}"
}

resource "aws_security_group_rule" "allow_bastion_ping" {
  type                     = "ingress"
  from_port                = 8
  to_port                  = 0
  protocol                 = "icmp"
  source_security_group_id = "${module.service.service_sg}"
  security_group_id        = "${data.terraform_remote_state.env.sg_env}"
}

resource "aws_security_group_rule" "allow_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${module.service.service_sg}"
  security_group_id        = "${data.terraform_remote_state.env.sg_env}"
}

resource "aws_security_group_rule" "allow_bastion_fan" {
  type                     = "ingress"
  from_port                = 8472
  to_port                  = 8472
  protocol                 = "udp"
  source_security_group_id = "${module.service.service_sg}"
  security_group_id        = "${data.terraform_remote_state.env.sg_env}"
}

resource "aws_security_group_rule" "allow_bastion_fan_return" {
  type                     = "ingress"
  from_port                = 8472
  to_port                  = 8472
  protocol                 = "udp"
  source_security_group_id = "${data.terraform_remote_state.env.sg_env}"
  security_group_id        = "${module.service.service_sg}"
}

