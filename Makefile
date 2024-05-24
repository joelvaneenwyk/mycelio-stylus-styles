package_manager := yarn
lock_file := yarn.lock

node_modules: $(lock_file)
	$(package_manager) install --no-save
	@touch node_modules

.PHONY: test
test: lint

.PHONY: build
build: node_modules clean
	node tools/build.js

.PHONY: deps
deps: node_modules

.PHONY: lint
lint: node_modules
	npx eslint --color src/gen tools
	npx stylelint --color src/**/*.css

.PHONY: lint-fix
lint-fix: node_modules
	npx eslint --color src/gen tools --fix
	npx stylelint --color src/**/*.css --fix

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
	npx updates -cu
	rm $(lock_file)
	$(package_manager) install
	@touch node_modules

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
