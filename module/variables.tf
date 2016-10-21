variable "aws_region" {}

variable "consul_dc" {
  default = "dc1"
}

provider "consul" {
  datacenter = "${var.consul_dc}"
}

provider "aws" {
  region = "${var.aws_region}"
}

data "aws_region" "current" {
  name = "${var.aws_region}"
}
