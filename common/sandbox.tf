variable sandbox_remote_state {}

data "terraform_remote_state" "sandbox" {
  backend = "local"

  config {
    path = "${var.sandbox_remote_state}"
  }
}
