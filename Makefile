etcdir ?= ./build/etc
prefix ?= ./build
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
endif

clean: | uninstall

dependencies: | apt brew

install: | stub
	@rsync -a src/ ${prefix}/bin/
ifeq (${uname}, Darwin)
	@$(eval _etcdir := $(shell greadlink -f ${etcdir}))
	@sed -i ''  "s|config=|config=${_etcdir}/slack-cli|g" ${prefix}/bin/slack
else ifeq (${uname}, Linux)
	@$(eval _etcdir := $(shell readlink -f ${etcdir}))
	@sed -i "s|config=|config=${_etcdir}/slack-cli|g" ${prefix}/bin/slack
endif

stub:
	@mkdir -p ${prefix}/bin
	@mkdir -p ${prefix}/etc

test: | install
	@test/slack

uninstall:
	@rm -rf ${prefix}

.PHONY: apt brew clean dependencies install stub test uninstall
