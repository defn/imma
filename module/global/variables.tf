variable "domain_name" {}

variable "aws_region" {}

variable "s3_remote_state" {}

output "aws_account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "s3_remote_state" {
  value = "${var.s3_remote_state}"
}

output "domain_name" {
  value = "${var.domain_name}"
}
