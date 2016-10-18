module "app" {
  source              = "../../module/app"
  global_remote_state = "${var.global_remote_state}"
  env_remote_state    = "${var.env_remote_state}"
  az_count            = "${var.az_count}"
  app_name            = "${var.app_name}"
}
