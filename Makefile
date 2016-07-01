TRAVIS ?= false

# don't lint bugs-found-by-musl.md due to intentionally long line length
lint:
	find . -type f -and -not -name 'bugs-found-by-musl.md' -and -not -name '_*' -and -name '*.md' -print0 | xargs -0 mdl -s .mdlstyle.rb

serve:
	gollum --h1-title --user-icons gravatar --no-edit --no-live-preview --host 127.0.0.1 --css --adapter rugged --base-path /wiki

install:
	@command -v gem >/dev/null 2>&1 || { echo "\`gem\` needs to be installed."; exit 1; }
	@echo "This target will install dependencies need to lint the markdown files,"
	@echo "and also locally run the wiki. If you do not want \`gem\` to install"
	@echo "markdownlint, gollum, rugged, and github-markdown, press Ctrl-C."
	@[ "$(TRAVIS)" = true ] || sleep 10
	@[ "$(TRAVIS)" = true ] || command -v gollum >/dev/null 2>&1 || gem install --verbose --no-document gollum; exit $$?
	@command -v mdl >/dev/null 2>&1 || gem install --verbose --no-document mdl; exit $$?
	@( gem list | grep -q "github-markdown" && exit $$? || exit 1 ) || gem install --verbose --no-document github-markdown; exit $$?
	@[ "$(TRAVIS)" = true ] || ( gem list | grep -q "gollum-rugged_adapter" && exit $$? || exit 1 ) || gem install --verbose --no-document gollum-rugged_adapter; exit $$?

.PHONY: lint serve install
