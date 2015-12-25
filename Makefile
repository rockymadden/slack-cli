CONFIG ?= ./build/etc/.slack
PREFIX ?= ./build
UNAME := $(shell uname -s)

ifeq (${UNAME}, Darwin)
_CONFIG := $(shell greadlink -f ${CONFIG})
else ifeq (${UNAME}, Linux)
_CONFIG := $(shell readlink -f ${CONFIG})
endif

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

install:
	@mkdir -p ${PREFIX}/bin
	@mkdir -p ${PREFIX}/etc
	@rsync -a src/ ${PREFIX}/bin/
ifeq (${UNAME}, Darwin)
	@sed -i ''  "s|config=|config=${_CONFIG}|g" ${PREFIX}/bin/slack
else ifeq (${UNAME}, Linux)
	@sed -i "s|config=|config=${_CONFIG}|g" ${PREFIX}/bin/slack
endif

test: | install
	@test/slack

uninstall:
	@rm -rf ${PREFIX}

.PHONY: apt brew clean dependencies install test uninstall
