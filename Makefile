.DEFAULT_GOAL := stub
bindir ?= ./build/bin
etcdir ?= ./build/etc

clean: | uninstall
	@rm -rf ./build

install: | stub
	@install -m 755 src/slk ${bindir}/slk
	@sed -i.bak -e "s|^bindir=.*|bindir=$(abspath ${bindir})|" -e "s|^etcdir=.*|etcdir=$(abspath ${etcdir})|" ${bindir}/slk
	@rm -f ${bindir}/slk.bak

stub:
	@mkdir -p ${bindir}
	@mkdir -p ${etcdir}

test: | test-unit test-shim

# Posts to live Slack channels; never part of `make test`.
test-integration: | install
	@bats test/integration

test-shim: | install
	@bats test/shim

test-unit: | install
	@bats test/unit

# Removes only the installed binary; bindir may be a shared directory like ~/.local/bin.
uninstall:
	@rm -f ${bindir}/slk

.PHONY: clean install stub test test-integration test-shim test-unit uninstall
