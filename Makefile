ROOT=$(shell stack --stack-yaml stack-ghcjs.yaml path --local-install-root)/bin/profiteur.jsexe
# Note: nodejs-externs is from https://github.com/dcodeIO/node.js-closure-compiler-externs.git
# You can `git clone https://github.com/dcodeIO/node.js-closure-compiler-externs.git nodejs-externs`
EXTERNS=$(shell find nodejs-externs/ -maxdepth 1 -name '*.js' | sed 's/^/--externs=/')

all: profiteur.js

profiteur.jsexe: src profiteur.cabal stack-ghcjs.yaml
	stack --stack-yaml stack-ghcjs.yaml build

profiteur.js: profiteur.jsexe
	closure-compiler $(ROOT)/all.js --compilation_level=ADVANCED_OPTIMIZATIONS $(EXTERNS) --externs=$(ROOT)/all.js.externs > profiteur.js

.PHONY: clean
clean:
	stack --stack-yaml stack-ghcjs.yaml clean hs
	rm profiteur.js
