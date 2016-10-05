module "env" {
  source              = "../fogg/env"
  global_remote_state = "${var.global_remote_state}"
}
