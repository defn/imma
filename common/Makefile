all:
	$(MAKE) links get fmt

fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

plan apply refresh get:
	terraform $@

output:
	@terraform output -json | jq .

etc/ssh-key-pair:
	mkdir -p etc
	ssh-keygen -f $@ -C "$(basename $(dirname $PWD))/$(basename $PWD)" -P ''

instances:
	 aws ec2 describe-instances | jq -r '[.Reservations[].Instances[]] | flatten | map(select(.State.Name == "running")) | map("\(.InstanceId) \(.State.Name) \((.Tags//[])[] | select(.Key == "aws:autoscaling:groupName") | .Value) \(.PrivateDnsName) \(.PublicDnsName)")[]' | sort -k2 | talign

remote links:
	$(MAKE) $(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD) | cut -d- -f1)-$@

env-%-remote:
	terraform remote config -backend=s3 -backend-config="bucket=imma-io-remote-state" -backend-config="region=us-west-1" -backend-config="key=$(shell basename $(shell pwd))/terraform.tfstate"

app-%-remote:
	terraform remote config -backend=s3 -backend-config="bucket=imma-io-remote-state" -backend-config="region=us-west-1" -backend-config="key=$(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD))/terraform.tfstate"

env-global-links:
	hcltool global.tf > _fogg.tf.json.1
	cat _fogg.tf.json.1 | jq -r '.module | map(.source)[]' | sort -u | (cat ../../module/export.json; runmany 'cat $$1/export.json') | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.2
	cat _fogg.tf.json.2 > _fogg.tf.json
	rm -f _fogg.tf.json.*

env-%-links:
	imma gen env > _fogg.tf.json.1
	cat _fogg.tf.json.1 | jq -r '.module | map(.source)[]' | sort -u | (cat ../../module/export.json; runmany 'cat $$1/export.json'; runmany 'hcltool ../../common/$$1.tf' global) | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.2
	jq -n --argfile app _fogg.tf.json.1 --argfile fogg _fogg.tf.json.2 '$$app * $$fogg' > _fogg.tf.json.3
	cat _fogg.tf.json.3 | jq '.variable.global_remote_state |= { default: "../../env/global/.terraform/terraform.tfstate" }' > _fogg.tf.json.4
	cat _fogg.tf.json.4 | jq --arg env_name $(shell basename $(PWD)) '.variable.env_name |= { default: $$env_name }' > _fogg.tf.json.5
	cat _fogg.tf.json.5 > _fogg.tf.json
	rm -f _fogg.tf.json.*

app-%-links: etc/ssh-key-pair
	imma gen app $(shell cat ../services) > _fogg.tf.json.1
	cat _fogg.tf.json.1 | jq -r '.module | map(.source)[]' | sort -u | (cat ../../module/export.json; runmany 'cat $$1/export.json'; runmany 'hcltool ../../common/$$1.tf' global) | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.2
	jq -n --argfile app _fogg.tf.json.1 --argfile fogg _fogg.tf.json.2 '$$app * $$fogg' > _fogg.tf.json.3
	cat _fogg.tf.json.3 | jq '.variable.global_remote_state |= { default: "../../env/global/.terraform/terraform.tfstate" }' > _fogg.tf.json.4
	cat _fogg.tf.json.4 | jq --arg env_name $(shell basename $(PWD)) '.variable.env_remote_state |= { default: "../../env/\($$env_name)/.terraform/terraform.tfstate" }' > _fogg.tf.json.5
	cat _fogg.tf.json.5 | jq --arg app_name $(shell basename $(shell dirname $(PWD)) | cut -d- -f2-) '.variable.app_name |= { default: $$app_name }' > _fogg.tf.json.6
	cat _fogg.tf.json.6 > _fogg.tf.json
	rm -f _fogg.tf.json.*
