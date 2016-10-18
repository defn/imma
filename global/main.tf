variable env_cidr {
  default = {
    "sandbox" = "172.16.0.0/16"
    "admin"   = "172.19.0.0/16"
    "dev"     = "172.20.0.0/16"
  }
}

variable sys_nets {
  default = {
    common = [2, 3, 4, 5]
    nat    = [10, 11, 12, 13]
  }
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
