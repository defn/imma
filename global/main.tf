variable "aws_account_id" {}

variable "domain_name" {}

variable "s3_remote_state" {}

module "global" {
  source          = "../fogg/global"
  aws_account_id  = "${var.aws_account_id}"
  domain_name     = "${var.domain_name}"
  s3_remote_state = "${var.s3_remote_state}"
}
