fmt:
	$(MAKE) links get
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

plan apply refresh get:
	terraform $@

output:
	@terraform output -json | jq .

remote links:
	$(MAKE) $(shell basename $(PWD) | cut -d- -f1)-$@

global-remote env-remote:
	terraform remote config -backend=s3 -backend-config="bucket=imma-io-remote-state" -backend-config="key=$(shell basename $(shell pwd))/terraform.tfstate"

global-links:
	ln -nfs ../common/Makefile .
	hcltool global.tf | jq -r '.module | map(.source)[]' | sort -u | (cat ../module/export.json; runmany 'cat $$1/export.json') | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.1
	mv _fogg.tf.json.1 _fogg.tf.json

env-links:
	ln -nfs ../common/Makefile ../common/env.tf .
	ln -nfs ../global/.terraform/terraform.tfstate .global.tfstate
	hcltool env.tf | jq -r '.module | map(.source)[]' | sort -u | (cat ../module/export.json; runmany 'cat $$1/export.json'; runmany 'hcltool ../common/$$1.tf' global $(shell cat .imma 2>/dev/null)) | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.1
	cat _fogg.tf.json.1 | jq --arg env_name $(shell echo $(PWD) | cut -d- -f2-) '.variable.env_name |= { default: $$env_name }' > _fogg.tf.json
	rm -f _fogg.tf.json.1

%-remote:
	$(MAKE) app-remote

app-remote:
	terraform remote config -backend=s3 -backend-config="bucket=imma-io-remote-state" -backend-config="key=$(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD))/terraform.tfstate" -backend-config="region=us-west-1"

%-links:
	$(MAKE) app-links

app-links:
	$(MAKE) key-pair
	ln -nfs ../../common/Makefile .
	ln -nfs ../../global/.terraform/terraform.tfstate .global.tfstate
	ln -nfs ../../env-$(shell basename $(PWD))/.terraform/terraform.tfstate .env.tfstate
	imma gen app $(shell cat ../services) > _fogg.tf.json.1
	cat _fogg.tf.json.1 | jq -r '.module | map(.source)[]' | sort -u | (cat ../../module/export.json; runmany 'cat $$1/export.json'; runmany 'hcltool ../../common/$$1.tf' global $(shell basename $(PWD))) | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.2
	jq -n --argfile app _fogg.tf.json.1 --argfile fogg _fogg.tf.json.2 '$$app * $$fogg' > _fogg.tf.json.3
	cat _fogg.tf.json.3 | jq --arg app_name $(shell basename $(shell dirname $(PWD)) | cut -d- -f2-) '.variable.app_name |= { default: $$app_name }' > _fogg.tf.json
	rm -f _fogg.tf.json.1 _fogg.tf.json.2 _fogg.tf.json.3

key-pair: etc/ssh-key-pair.pub

etc/ssh-key-pair.pub:
	mkdir -p etc
	ssh-keygen -f etc/ssh-key-pair -C "$(basename $(dirname $PWD))/$(basename $PWD)" -P ''

instances:
	 aws ec2 describe-instances | jq -r '[.Reservations[].Instances[]] | flatten | map(select(.State.Name == "running")) | map("\(.InstanceId) \(.State.Name) \((.Tags//[])[] | select(.Key == "aws:autoscaling:groupName") | .Value) \(.PrivateDnsName) \(.PublicDnsName)")[]' | sort -k2 | talign
