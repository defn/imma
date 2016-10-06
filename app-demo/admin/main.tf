variable admin_remote_state {}

module "app" {
  source              = "../../fogg/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  app_name            = "${var.app_name}"
  az_count            = "${var.az_count}"
  az_names            = ["${var.az_names}"]
  app_bits            = "${var.app_bits}"
  app_nets            = ["${var.app_nets}"]
}
