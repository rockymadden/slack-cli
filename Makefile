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

install:
	@mkdir -p ${PREFIX}/bin
	@rsync -a src/ ${PREFIX}/bin/

test: | install
	@test/slack

uninstall:
	@rm -rf ${PREFIX}

.PHONY: apt brew clean dependencies install test uninstall
