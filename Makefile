fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

refresh:
	runmany 'cd env/$$1 && make && make refresh && make plan || true' global sandbox dev admin reland network prod stage
