provider "aws" {
  region = "${var.aws_region}"
}

module "global" {
  source          = "../../module/global"
  domain_name     = "${var.domain_name}"
  aws_region      = "${var.aws_region}"
  s3_remote_state = "${var.s3_remote_state}"
}

output env_cidr {
  value = "${var.env_cidr}"
}

output env_region {
  value = "${var.env_region}"
}

output sys_nets {
  value = "${var.sys_nets}"
}

output service_nets {
  value = "${var.service_nets}"
}
