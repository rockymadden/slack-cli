bindir ?= ./build/bin
etcdir ?= ./build/etc
uname := $(shell uname -s)

apt:
ifeq (${uname}, Linux)
	@add-apt-repository ppa:duggan/bats -y
	@apt-get update
	@apt-get install bats
	@apt-get install jq
endif

brew:
ifeq (${uname}, Darwin)
	@brew install bats
	@brew install jq
endif

clean: | uninstall

dependencies: | apt brew

install: | stub
	@rsync -a src/ ${bindir}/
ifeq (${uname}, Darwin)
	@$(eval _bindir := $(shell greadlink -f ${bindir}))
	@$(eval _etcdir := $(shell greadlink -f ${etcdir}))
	@sed -i ''  "s|bindir=|bindir=${_bindir}|g" ${bindir}/slack
	@sed -i ''  "s|etcdir=|etcdir=${_etcdir}|g" ${bindir}/slack
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

.PHONY: apt brew clean dependencies install stub test uninstall
