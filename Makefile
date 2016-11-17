fmt:
	runmany 'terraform fmt $$1' $(shell find . -name '*.tf' -o -name '*.tfvars')
	mkdir -p module
	for a in ../fogg/module/*/; do ln -nfs ../$$a module/; done
