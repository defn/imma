domain_name = "imma.io"

s3_remote_state = "imma-io-remote-state"

aws_account_id = "548373030883"

env_cidr = {
  "sandbox" = "172.16.0.0/16"
  "admin"   = "172.19.0.0/16"
  "dev"     = "172.20.0.0/16"
}

sys_nets = {
  common = [2, 3, 4, 5]
  nat    = [10, 11, 12, 13]
}

service_nets = {
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
