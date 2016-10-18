variable env_cidr {
  default = {}
}

variable sys_nets {
  default {}
}

variable service_nets {
  default = {}
}

variable public_network {
  default = {}
}

variable want_fs {
  default = {}
}

module "global" {
  source          = "../fogg/global"
  aws_account_id  = "${var.aws_account_id}"
  domain_name     = "${var.domain_name}"
  s3_remote_state = "${var.s3_remote_state}"
}

output env_cidr {
  value = "${var.env_cidr}"
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
