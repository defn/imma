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

remote:
	$(MAKE) $(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD) | cut -d- -f1)-$@

env-%-remote:
	terraform remote config -backend=s3 -backend-config="bucket=imma-io-remote-state" -backend-config="region=$(shell hcltool ../../env/global/terraform.tfvars | jq -r '.aws_region')" -backend-config="key=env-$(shell basename $(shell pwd))/terraform.tfstate"

app-%-remote:
	terraform remote config -backend=s3 -backend-config="bucket=imma-io-remote-state" -backend-config="region=$(shell hcltool ../../env/global/terraform.tfvars | jq -r '.aws_region')" -backend-config="key=$(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD))/terraform.tfstate"

links:
	$(MAKE) $(shell basename $(shell dirname $(PWD)))-$(shell basename $(PWD) | cut -d- -f1)-$@

env-global-links:
	imma gen global > _fogg.tf.json

env-%-links:
	imma gen env "$(shell basename $(PWD))" > _fogg.tf.json

app-%-links: etc/ssh-key-pair
	imma gen app "$(shell basename $(PWD))" "$(shell basename $(shell dirname $(PWD)) | cut -d- -f2-)" $(shell cat ../services) > _fogg.tf.json
