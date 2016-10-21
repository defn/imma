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
	terraform remote config -backend=s3 -backend-config="bucket=imma-io-remote-state" -backend-config="region=$(shell hcltool ../../env/global/terraform.tfvars | jq -r '.aws_region')" -backend-config="key=env-$(shell basename $(shell pwd))/terraform.tfstate"

app-%-remote:
	terraform remote config -backend=s3 -backend-config="bucket=imma-io-remote-state" -backend-config="region=$(shell hcltool ../../env/global/terraform.tfvars | jq -r '.aws_region')" -backend-config="key=$(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD))/terraform.tfstate"

env-global-links:
	imma gen global > _fogg.tf.json

env-%-links:
	imma gen env > _fogg.tf.json.seed
	cat _fogg.tf.json.seed | jq -r '.module | map(.source)[]' | sort -u | (runmany 'cat $$1/export.json'; runmany 'hcltool ../../common/$$1.tf' global) | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.modules
	jq -n --argfile seed _fogg.tf.json.seed \
		    --argfile modules _fogg.tf.json.modules \
	      --arg env_name $(shell basename $(PWD)) \
		     '$$seed * $$modules | \
	      	.variable.global_remote_state |= { default: "../../env/global/.terraform/terraform.tfstate" } | \
					.variable.env_name            |= { default: "\($$env_name)" }' > _fogg.tf.json.final
	$(MAKE) cleanup

app-%-links: etc/ssh-key-pair
	imma gen app $(shell cat ../services) > _fogg.tf.json.seed
	cat _fogg.tf.json.seed | jq -r '.module | map(.source)[]' | sort -u | (runmany 'cat $$1/export.json'; runmany 'hcltool ../../common/$$1.tf' global) | jq -s 'reduce .[] as $$exp ({}; . * $$exp)' > _fogg.tf.json.modules
	jq -n --argfile seed _fogg.tf.json.seed \
		    --argfile modules _fogg.tf.json.modules \
	      --arg env_name $(shell basename $(PWD)) \
		    --arg app_name $(shell basename $(shell dirname $(PWD)) | cut -d- -f2-) \
		     '$$seed * $$modules | \
	        .variable.global_remote_state |= { default: "../../env/global/.terraform/terraform.tfstate" } | \
	        .variable.env_remote_state    |= { default: "../../env/\($$env_name)/.terraform/terraform.tfstate" } | \
          .variable.app_name            |= { default: "\($$app_name)" }' > _fogg.tf.json.final
	$(MAKE) cleanup

cleanup:
	mv -f _fogg.tf.json.final _fogg.tf.json
	rm -f _fogg.tf.json.*
