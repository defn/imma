fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

plan:
	terraform plan

apply:
	terraform apply

output:
	@terraform output -json | jq .

bootstrap remote links:
	$(MAKE) $(shell basename $(PWD) | cut -d- -f1)-$@

global-bootstrap env-bootstrap:
	terraform get
	aws s3 cp s3://imma-io-remote-state/$(shell basename $(PWD))/terraform.tfstate .terraform/

global-remote env-remote:
	terraform remote config -backend=s3 -backend-config="bucket=$(shell terraform output -json | jq -r .s3_remote_state.value)" -backend-config="key=$(shell basename $(shell pwd))/terraform.tfstate"

global-links:
	ln -nfs ../common/Makefile .
	hcltool main.tf | jq -r '.module | map(.source)[]' | sort -u | (cat ../fogg/export.json; runmany 'cat $$1/export.json') | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.1
	mv _fogg.tf.json.1 _fogg.tf.json

env-links:
	ln -nfs ../common/Makefile .
	hcltool main.tf | jq -r '.module | map(.source)[]' | sort -u | (cat ../fogg/export.json; runmany 'cat $$1/export.json'; runmany 'hcltool ../common/$$1.tf' global $(shell cat .imma 2>/dev/null)) | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.1
	mv _fogg.tf.json.1 _fogg.tf.json

%-bootstrap:
	$(MAKE) app-bootstrap

app-bootstrap:
	aws s3 cp s3://imma-io-remote-state/$(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD))/terraform.tfstate .terraform/

%-remote:
	$(MAKE) app-remote

app-remote:
	terraform remote config -backend=s3 -backend-config="bucket=$(shell terraform output -json | jq -r .s3_remote_state.value)" -backend-config="key=$(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD))/terraform.tfstate"

%-links:
	$(MAKE) app-links

app-links:
	ln -nfs ../../common/Makefile .
	hcltool main.tf | jq -r '.module | map(.source)[]' | sort -u | (cat ../../fogg/export.json; runmany 'cat $$1/export.json'; runmany 'hcltool ../../common/$$1.tf' global $(shell basename $(PWD))) | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.1
	mv _fogg.tf.json.1 _fogg.tf.json

key-pair: etc/key-pair.pub

etc/key-pair.pub:
	mkdir -p etc
	ssh-keygen -P "" -C "$(shell basename $(PWD))" -f etc/key-pair
