data "terraform_remote_state" "global" {
  backend = "local"

  config {
    path = "${var.global_remote_state}"
  }
}

output "s3_remote_state" {
  value = "${data.terraform_remote_state.global.s3_remote_state}"
}
