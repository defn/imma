module "SERVICE" {
  service_name        = "SERVICE"
  service_nets        = ["${data.terraform_remote_state.global.service_nets["SERVICE"]}"]
  public_network      = "${var.public_network["SERVICE"]}"
  want_fs             = "${var.want_fs["SERVICE"]}"
  source              = "../../fogg/service"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  security_groups     = ["${module.app.app_sg}"]
  instance_type       = ["${var.instance_type}"]
  user_data           = "${var.user_data}"
}
