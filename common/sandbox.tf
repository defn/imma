variable env_remote_state {}

data "terraform_remote_state" "sandbox" {
  backend = "local"

  config {
    path = "${var.env_remote_state}"
  }
}
