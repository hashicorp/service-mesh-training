build_what_is:
	@echo Building what is deck
	@md2gslides ./what_is/what_is.md -t "QCon 2019 - Service mesh overview" -n -c ${DEFAULT_TEMPLATE}

build_security:
	@echo Building security deck
	@md2gslides ./security/security.md -t "QCon 2019 - Security" -n -c ${DEFAULT_TEMPLATE}

build_observability:
	@echo Building observability deck
	@md2gslides ./observability/observability.md -t "QCon 2019 - Observability" -n -c ${DEFAULT_TEMPLATE}

update_observability:
	@echo Updating observability deck
	@md2gslides ./observability/observability.md -a ${OBSERVABILITY_DECK_ID} -e -n
