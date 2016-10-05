data "terraform_remote_state" "dev" {
  backend = "local"

  config {
    path = "${var.dev_remote_state}"
  }
}
