runner := $(shell basename $(shell dirname $(PWD)))

fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf')

remote:
	$(runner) terraform remote config -backend=s3 -backend-config="bucket=$(shell hcltool terraform.tfvars  | jq -r '.s3_remote_state')" -backend-config="key=$(shell basename $(shell pwd))/terraform.tfstate"

plan:
	$(runner) terraform get
	$(runner) terraform plan

apply:
	$(runner) terraform apply
