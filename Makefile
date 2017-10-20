TRAVIS ?= false

# requires discount markdown, postcss-cli, cssnano, htmltidy (html5), and autoprefixer

SRCDIR          := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
IMAGE           ?= /srv/www/wiki.musl-libc.org

all: $(addsuffix .html,$(basename $(shell find -type f -name '*.md')))
all: $(addsuffix .min.css,$(basename $(shell find -type f -name '*.css' -and -not -name '*.min.css')))

clean:
	find -type f -name '*.html' -delete -print
	find -type f -name '*.min.css' -delete -print
	find -type f -name '*.tmp' -delete -print

lint:
	@find -type f -name '*.md' -and -not -name 'bugs-found-by-musl.md' -print0 | xargs -t0 mdl -s .mdlstyle.rb

install:
	- gem install mdl
	- npm install -g postcss-cli cssnano autoprefixer

# cssnano is ran separately because it likes to take out vendor prefixes we might still need
%.min.css: %.css
	postcss -u cssnano "$*.css" -o "$*.css.tmp"
	postcss -u autoprefixer "$*.css.tmp" -o "$*.min.css"
	rm -f "$*.css.tmp"

%.html: %.md $(shell $(SRCDIR)/scripts/markdown.sh --template "$<" "$@")
	$(SRCDIR)/scripts/markdown.sh "$<" "$@"
	tidy -w 0 -utf8 -language en -i -m --show-info no "$@"

watch:
	while true; do \
	    { find . -not -name '*.min.css' -and -not -name '*.tmp' -and -not -name '*.html'; } | entr -c sh -c '$(MAKE) lint && $(MAKE)'; \
	done

deploy: all
	rm -f $(IMAGE)/Makefile
	rm -f $(shell find "$(IMAGE)" -type f -name '*.css' -and -not -name '*.min.css')
	rm -f $(shell find "$(IMAGE)" -type f -name '*.md' -or -name '*.theme' -or -name '*.tmp')

.PHONY: all clean deploy lint watch
