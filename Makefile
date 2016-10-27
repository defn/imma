fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

refresh:
	runmany 'cd env/$$1 && make clean && make && make refresh && make plan' global sandbox dev admin ireland network prod stage
