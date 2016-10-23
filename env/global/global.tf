module "global" {
  source          = "../../module/global"
  domain_name     = "${var.domain_name}"
  aws_account_id  = "${var.aws_account_id}"
  aws_region      = "${var.aws_region}"
  s3_remote_state = "${var.s3_remote_state}"
}

output env {
  value = "${var.env}"
}

output sys_nets {
  value = "${var.sys_nets}"
}

output service_nets {
  value = "${var.service_nets}"
}

output public_network {
  value = "${var.public_network}"
}

output want_fs {
  value = "${want_fs}"
}
