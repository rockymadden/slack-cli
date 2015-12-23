PREFIX ?= ./build

clean: | uninstall

install:
	@mkdir -p ${PREFIX}/bin
	@rsync -a src/ ${PREFIX}/bin/

test: | install
	@test/slack

uninstall:
	@rm -rf ${PREFIX}

.PHONY: clean install test uninstall
