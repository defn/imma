variable env_remote_state {}

data "terraform_remote_state" "admin" {
  backend = "local"

  config {
    path = "${var.env_remote_state}"
  }
}
