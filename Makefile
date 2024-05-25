package_manager := yarn
lock_file := yarn.lock
package_state := .yarn/install-state.gz

.yarn/install-state.gz: $(lock_file)
	sudo npm install -g corepack
	sudo corepack enable
	$(package_manager) install

.PHONY: node_modules
node_modules: .yarn/install-state.gz

.PHONY: all
all: build lint authors update

.PHONY: test
test: lint

.PHONY: build
build: node_modules clean
	node tools/build.js

.PHONY: deps
deps: node_modules

.PHONY: lint
lint: node_modules
	yarn lint

.PHONY: lint-fix
lint-fix: node_modules
	yarn lint:fix

.PHONY: authors
authors:
	bash tools/authors.sh

.PHONY: clean
clean: node_modules
	node tools/clean.js

.PHONY: install
install: node_modules
	node tools/install.js

.PHONY: update
update: node_modules
	npx -y updates -cu
	rm -rf $(lock_file) $(package_state)
	$(package_manager) install

.PHONY: patch
patch: node_modules test
	npx versions -pd patch $(wildcard *.user.css) package.json $(lock_file)
	git push --tags origin master

.PHONY: minor
minor: node_modules test
	npx versions -pd minor $(wildcard *.user.css) package.json $(lock_file)
	git push --tags origin master

.PHONY: major
major: node_modules test
	npx versions -pd major $(wildcard *.user.css) package.json $(lock_file)
	git push --tags origin master
