module "SERVICE" {
  source              = "../../module/service"
  global_remote_state = "${data.terraform_remote_state.env.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
  service_name        = "SERVICE"
  service_nets        = ["${data.terraform_remote_state.global.service_nets.SERVICE}"]
  public_network      = "${lookup(var.public_network,"SERVICE","0")}"
  want_fs             = "${lookup(var.want_fs,"SERVICE","0")}"
  security_groups     = ["${module.app.app_sg}"]
  instance_type       = ["${lookup(var.instance_type,"SERVICE","t2.nano")}"]
  user_data           = "${var.user_data}"
  public_key          = "${var.public_key}"
}
