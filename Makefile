PREFIX ?= .

clean:
	@-rm -rf ${PREFIX}/bin

install: | stub
	@-rsync -a src/ ${PREFIX}/bin/

stub:
	@-mkdir -p ${PREFIX}/bin

test: | install
	@-echo 'slack:'
	@-test/slack

.PHONY: clean install stub test
