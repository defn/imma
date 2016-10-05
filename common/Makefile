runner := $(shell basename $(shell dirname $(PWD)))

fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

remote:
	$(runner) terraform remote config -backend=s3 -backend-config="bucket=$(shell $(runner) terraform output -json | jq -r .s3_remote_state.value)" -backend-config="key=$(shell basename $(shell pwd))/terraform.tfstate"

plan:
	$(runner) terraform get
	$(runner) terraform plan

apply:
	$(runner) terraform apply

output:
	@$(runner) terraform output -json | jq .

links:
	ln -nfs ../common/Makefile .
	ln -nfs ../common/global.tf .
