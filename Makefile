.DEFAULT_GOAL := stub
bindir ?= ./build/bin
etcdir ?= ./build/etc
uname := $(shell uname -s)

clean: | uninstall

install: | stub
	@rsync -a src/ ${bindir}/
ifeq (${uname}, Darwin)
	@$(eval _bindir := $(shell greadlink -f ${bindir}))
	@$(eval _etcdir := $(shell greadlink -f ${etcdir}))
	@sed -i '' "s|bindir=|bindir=${_bindir}|g" ${bindir}/slack
	@sed -i '' "s|etcdir=|etcdir=${_etcdir}|g" ${bindir}/slack
else ifeq (${uname}, Linux)
	@$(eval _bindir := $(shell readlink -f ${bindir}))
	@$(eval _etcdir := $(shell readlink -f ${etcdir}))
	@sed -i "s|bindir=|bindir=${_bindir}|g" ${bindir}/slack
	@sed -i "s|etcdir=|etcdir=${_etcdir}|g" ${bindir}/slack
endif

stub:
	@mkdir -p ${bindir}
	@mkdir -p ${etcdir}

test: | install
	@test/slack

uninstall:
	@rm -rf ${bindir}
	@rm -rf ${etcdir}

.PHONY: clean install stub test uninstall
