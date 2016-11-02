fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

refresh:
	runmany 'cd org/$$1 && fogg plan' imma
	runmany 2 'cd org/imma/$$1 && fogg plan' sandbox dev admin ireland network prod stage

apply:
	runmany 'cd org/$$1 && fogg apply' imma
	runmany 2 'cd org/imma/$$1 && fogg apply' sandbox dev admin ireland network prod stage
