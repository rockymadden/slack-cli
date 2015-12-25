CONFIG ?= ./build/etc/.slack
PREFIX ?= ./build
UNAME := $(shell uname -s)

apt:
ifeq (${UNAME}, Linux)
	@add-apt-repository ppa:duggan/bats -y
	@apt-get update
	@apt-get install bats
endif

brew:
ifeq (${UNAME}, Darwin)
	@brew install bats
endif

clean: | uninstall

dependencies: | apt brew

install: | stub
	@rsync -a src/ ${PREFIX}/bin/
ifeq (${UNAME}, Darwin)
	@$(eval _CONFIG := $(shell greadlink -f ${CONFIG}))
	@sed -i ''  "s|config=|config=${_CONFIG}|g" ${PREFIX}/bin/slack
else ifeq (${UNAME}, Linux)
	@$(eval _CONFIG := $(shell readlink -f ${CONFIG}))
	@sed -i "s|config=|config=${_CONFIG}|g" ${PREFIX}/bin/slack
endif

stub:
	@mkdir -p ${PREFIX}/bin
	@mkdir -p ${PREFIX}/etc

test: | install
	@test/slack

uninstall:
	@rm -rf ${PREFIX}

.PHONY: apt brew clean dependencies install stub test uninstall
