fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

bootstrap:
	terraform get
	aws s3 cp s3://imma-io-remote-state/$(shell basename $(PWD))/terraform.tfstate .

remote:
	terraform remote config -backend=s3 -backend-config="bucket=$(shell terraform output -json | jq -r .s3_remote_state.value)" -backend-config="key=$(shell basename $(shell pwd))/terraform.tfstate"

plan:
	terraform plan

apply:
	terraform apply

output:
	@terraform output -json | jq .

links:
	ln -nfs ../common/Makefile .
	ln -nfs ../common/global.tf .

key-pair: etc/key-pair.pub

etc/key-pair.pub:
	mkdir -p etc
	ssh-keygen -P "" -C "$(shell basename $(PWD))" -f etc/key-pair
