fmt:
	@runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')

refresh:
	cd global && terraform refresh
	cd env-sandbox && terraform refresh
	cd env-dev && terraform refresh
	cd env-admin && terraform refresh
