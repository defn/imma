resource "aws_security_group_rule" "allow_env_mount" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = "${module.env.sg_env}"
  security_group_id        = "${module.env.sg_efs}"
}
