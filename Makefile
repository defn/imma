fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

refresh:
	runmany 'cd org/$$1 && fogg && fogg remote && terraform get && terraform refresh && terraform plan' imma
	runmany 2 'cd org/imma/$$1 && fogg && fogg remote && terraform get && terraform refresh && terraform plan' sandbox dev admin ireland network prod stage
