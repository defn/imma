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

resource "aws_s3_bucket" "billing" {
  bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-billing"
  acl    = "private"

  logging {
    target_bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-s3"
    target_prefix = "log/"
  }

  policy = <<EOF
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetBucketAcl", 
				"s3:GetBucketPolicy"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::b-${format("%.8s",sha1(var.aws_account_id))}-global-billing",
      "Principal": {
        "AWS": [
          "${data.aws_billing_service_account.global.id}"
        ]
      }
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::b-${format("%.8s",sha1(var.aws_account_id))}-global-billing/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_billing_service_account.global.id}"
        ]
      }
    }
  ]
}
EOF

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

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "b-${format("%.8s",sha1(var.aws_account_id))}-global-cloudtrail"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::b-${format("%.8s",sha1(var.aws_account_id))}-global-cloudtrail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::b-${format("%.8s",sha1(var.aws_account_id))}-global-cloudtrail/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF
}
