PREFIX ?= .

clean:
	@-rm -rf ${PREFIX}/bin

install: | stub
	@-mkdir -p ${PREFIX}/bin
	@-rsync -a src/ ${PREFIX}/bin/

test: | install
	@-test/slack

.PHONY: clean install test
