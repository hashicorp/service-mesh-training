build_security:
	@echo Building security deck
	@docker run --rm -it -v $(shell pwd):/slides/ -v ${HOME}/.credentials:/home/node/.credentials --user $(shell id -u)  nicholasjackson/md2gslides /slides/security/security.md -t "QCon 2019 - Security" -n -c ${DEFAULT_TEMPLATE}
