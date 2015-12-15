PREFIX ?= .

clean:
	@-rm -rf ${PREFIX}/bin

install: | stub
	@-rsync -a src/ ${PREFIX}/bin/

stub:
	@-mkdir -p ${PREFIX}/bin

.PHONY: clean install stub
