data "consul_keys" "app" {
  key {
    name    = "aptly_nets"
    path    = "app/${var.app_name}/aptly/nets"
    default = "111 112 113"
  }

  key {
    name    = "nexus_nets"
    path    = "app/${var.app_name}/nexus/nets"
    default = "114 115 116"
  }

  key {
    name    = "dns_nets"
    path    = "app/${var.app_name}/dns/nets"
    default = "117 118 119"
  }

  key {
    name    = "ntp_nets"
    path    = "app/${var.app_name}/ntp/nets"
    default = "120 121 122"
  }
}

module "app" {
  source              = "../../fogg/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}

module "aptly" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "aptly"
  service_nets        = ["${split(" ",data.consul_keys.app.var.aptly_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}

module "nexus" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "nexus"
  service_nets        = ["${split(" ",data.consul_keys.app.var.nexus_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}

module "dns" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "dns"
  service_nets        = ["${split(" ",data.consul_keys.app.var.dns_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}

module "ntp" {
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "ntp"
  service_nets        = ["${split(" ",data.consul_keys.app.var.ntp_nets)}"]
  security_groups     = ["${module.app.app_sg}"]
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}
