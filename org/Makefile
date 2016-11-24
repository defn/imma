default: .etc/ssh-key-pair.pub
	@true

.etc/ssh-key-pair.pub:
	cp ~/.ssh/authorized_keys .etc/ssh-key-pair.pub

remote:
	$(shell basename $(PWD)) remote
	runmany 3 'cd $$1 && if ! test -d .terraform; then $(shell basename $(PWD)) remote | tee remote.log; fi' */
	runmany 3 'cd $$1 && if ! test -d .terraform; then $(shell basename $(PWD)) remote | tee remote.log; fi' */*/
	runmany 3 'cd $$1 && if ! test -d .terraform; then $(shell basename $(PWD)) remote | tee remote.log; fi' */*/*/

plan:
	$(shell basename $(PWD)) plan
	runmany 3 'cd $$1 && if test -d .terraform; then $(shell basename $(PWD)) plan | tee plan.log; fi' */
	runmany 3 'cd $$1 && if test -d .terraform; then $(shell basename $(PWD)) plan | tee plan.log; fi' */*/
	runmany 3 'cd $$1 && if test -d .terraform; then $(shell basename $(PWD)) plan | tee plan.log; fi' */*/*/

apply:
	$(shell basename $(PWD)) apply
	runmany 3 'cd $$1 && if test -d .terraform; then $(shell basename $(PWD)) apply | tee apply.log; fi' */
