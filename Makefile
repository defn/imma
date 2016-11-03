fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

refresh:
	runmany 'cd org/$$1 && imma plan' imma
	runmany 3 'cd org/imma/$$1 && imma plan' sandbox dev admin ireland network prod stage

apply:
	runmany 'cd org/$$1 && imma apply' imma
	runmany 3 'cd org/imma/$$1 && imma apply' sandbox dev admin ireland network prod stage
