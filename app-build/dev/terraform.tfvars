env_remote_state = "../../env-dev/.terraform/terraform.tfstate"

global_remote_state = "../../global/.terraform/terraform.tfstate"

az_count = "3"

app_name = "build"

instance_type = ["t2.nano", "t2.nano"]

want_fs = {
  "packer" = "0"
  "blocks" = "1"
}
