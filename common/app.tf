variable public_network {
  default = {
    openvpn = "0"
    bastion = "0"
    packer  = "0"
    blocks  = "0"
    aptly   = "0"
    nexus   = "0"
    dns     = "0"
    ntp     = "0"
    irssi   = "0"
  }
}

variable want_fs {
  default = {
    openvpn = "0"
    bastion = "0"
    packer  = "0"
    blocks  = "0"
    aptly   = "0"
    nexus   = "0"
    dns     = "0"
    ntp     = "0"
    irssi   = "0"
  }
}

module "app" {
  source              = "../../fogg/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}
