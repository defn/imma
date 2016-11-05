variable sys_nets {
  default = {
    _reserved_24 = [0, 1, 6]
    common       = [2, 3, 4, 5]
    _reserved_28 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    nat          = [10, 11, 12, 13]
  }
}

variable service_nets {
  default = {
    _reserved_services = [96, 97, 98]
    openvpn            = [99, 100, 101, 1000]
    bastion            = [102, 103, 104, 1001]
    irssi              = [105, 106, 107, 1006]
    packer             = [108, 109, 110, 1007]
    blocks             = [123, 124, 125, 1008]
    aptly              = [111, 112, 113, 1002]
    nexus              = [114, 115, 116, 1003]
    dns                = [117, 118, 119, 1004]
    ntp                = [120, 121, 122, 1005]
  }
}

variable env_cidr {
  default = {
    admin = "172.24.0.0/16"
  }
}

variable env_region {
  default = {
    admin = "us-east-1"
  }
}
