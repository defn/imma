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

variable service_nets {
  default = {
    openvpn = [99, 100, 101, 1000]
    bastion = [102, 103, 104, 1001]
    irssi   = [105, 106, 107, 1006]
    packer  = [108, 109, 110, 1007]
    blocks  = [123, 124, 125, 1008]
    aptly   = [111, 112, 113, 1002]
    nexus   = [114, 115, 116, 1003]
    dns     = [117, 118, 119, 1004]
    ntp     = [120, 121, 122, 1005]
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

output service_nets {
  value = "${var.service_nets}"
}
