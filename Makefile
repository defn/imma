fmt:
	@runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

refresh:
	runmany 'cd env/$1 && make refresh' global sandbox dev admin
