plan:
	$(shell basename $(PWD)) plan
	runmany 3 'cd $$1 && if test -d .terraform; then $(shell basename $(PWD)) plan | tee plan.log; fi' */

apply:
	$(shell basename $(PWD)) apply
	runmany 3 'cd $$1 && if test -d .terraform; then $(shell basename $(PWD)) apply | tee apply.log; fi' */
