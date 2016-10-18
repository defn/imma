variable env_remote_state { default = ".env.tfstate" }

data "terraform_remote_state" "env" {
  backend = "local"

  config {
    path = "${var.env_remote_state}"
  }
}
