env_remote_state = "../../env-admin/.terraform/terraform.tfstate"

global_remote_state = "../../global/.terraform/terraform.tfstate"

az_count = "4"

app_name = "access"

instance_type = ["t2.nano", "t2.nano"]

public_network = {
  bastion = "1"
  openvpn = "1"
}
