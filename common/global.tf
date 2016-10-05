data "terraform_remote_state" "global" {
  backend = "local"

  config {
    path = "${path.module}/../global/.terraform/terraform.tfstate"
  }
}

output "s3_remote_state" {
  value = "${data.terraform_remote_state.global.s3_remote_state}"
}
