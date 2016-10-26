variable "app_name" {}

variable "az_count" {}

variable "public_key" {
  default = "etc/ssh-key-pair.pub"
}

variable "user_data" {
  default = "etc/user-data.template"
}

output "app_sg" {
  value = "${aws_security_group.app.id}"
}
