resource "aws_security_group_rule" "allow_build_mount" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = "${module.app.app_sg}"
  security_group_id        = "${data.terraform_remote_state.env.sg_efs}"
}
