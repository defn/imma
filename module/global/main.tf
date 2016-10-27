resource "aws_iam_group" "administrators" {
  name = "administrators"
}

resource "aws_iam_group_policy_attachment" "administrators_iam_full_access" {
  group      = "${aws_iam_group.administrators.name}"
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "administrators_administrator_access" {
  group      = "${aws_iam_group.administrators.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_s3_bucket" "remote_state" {
  bucket = "${var.s3_remote_state}"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    "ManagedBy" = "terraform"
    "Env"       = "global"
  }
}

resource "aws_s3_bucket" "s3-meta" {
  bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-s3-meta"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  tags {
    "ManagedBy" = "terraform"
    "Env"       = "global"
  }
}

resource "aws_s3_bucket" "s3" {
  bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-s3"
  acl    = "log-delivery-write"

  logging {
    target_bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-s3-meta"
    target_prefix = "log/"
  }

  versioning {
    enabled = true
  }

  tags {
    "ManagedBy" = "terraform"
    "Env"       = "global"
  }
}

resource "aws_s3_bucket" "tf_remote_state" {
  bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-tf-remote-state"
  acl    = "private"

  logging {
    target_bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-s3"
    target_prefix = "log/"
  }

  versioning {
    enabled = true
  }

  tags {
    "ManagedBy" = "terraform"
    "Env"       = "global"
  }
}

data "aws_billing_service_account" "global" {}

data "template_file" "billing" {
  template = "${file("${path.module}/etc/iam-s3-billing.json")}"

  vars {
    bucket     = "b-${format("%.8s",sha1(var.aws_account_id))}-global-billing"
    billing_id = "${data.aws_billing_service_account.global.id}"
  }
}

resource "aws_s3_bucket" "billing" {
  bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-billing"
  acl    = "private"

  logging {
    target_bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-s3"
    target_prefix = "log/"
  }

  policy = "${data.template_file.billing.rendered}"

  versioning {
    enabled = true
  }

  tags {
    "ManagedBy" = "terraform"
    "Env"       = "global"
  }
}

resource "aws_cloudtrail" "global" {
  name                          = "global-cloudtrail"
  s3_bucket_name                = "b-${format("%.8s",sha1(var.aws_account_id))}-global-cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = true
}

data "template_file" "cloudtrail" {
  template = "${file("${path.module}/etc/iam-s3-cloudtrail.json")}"

  vars {
    bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-cloudtrail"
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-cloudtrail"

  policy = "${data.template_file.cloudtrail.rendered}"
}
