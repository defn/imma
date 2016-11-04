refresh:
	runmany 'cd $$1 && imma plan' imma
	runmany 3 'cd imma/$$1 && imma plan' sandbox dev admin ireland network prod stage

apply:
	runmany 'cd $$1 && imma apply' imma
	runmany 3 'cd imma/$$1 && imma apply' sandbox dev admin ireland network prod stage
