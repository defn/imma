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
