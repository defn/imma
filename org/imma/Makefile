all: _fogg.tf.json
	$(MAKE) fmt

.terraform/terraform.tfstate:
	$(MAKE) remote

_fogg.tf.json:
	$(MAKE) links

fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

clean:
	rm -f _fogg.tf.json

plan apply refresh get: _fogg.tf.json
	terraform $@

output:
	@terraform output -json | jq .

instances:
	 aws ec2 describe-instances | jq -r '[.Reservations[].Instances[]] | flatten | map(select(.State.Name == "running")) | map("\(.InstanceId) \(.State.Name) \((.Tags//[])[] | select(.Key == "aws:autoscaling:groupName") | .Value) \(.PrivateDnsName) \(.PublicDnsName)")[]' | sort -k2 | talign

remote:
	$(MAKE) $(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD) | cut -d- -f1)-$@

links:
	mkdir -p etc
	$(MAKE) $(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD) | cut -d- -f1)-$@

org-%-remote:
	terraform remote config -backend=s3 -backend-config="bucket=$(shell hcltool terraform.tfvars | jq -r '.s3_remote_state')" -backend-config="region=$(shell hcltool terraform.tfvars | jq -r '.aws_region')" -backend-config="key=$(shell basename $(shell pwd))/terraform.tfstate"

org-%-links:
	imma gen global > _fogg.tf.json.1
	mv _fogg.tf.json.1 _fogg.tf.json
