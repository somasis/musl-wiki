TRAVIS ?= false

# requires discount markdown, postcss-cli, cssnano, htmltidy (html5), and autoprefixer

SRCDIR          := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
WORK            ?= $(PWD)/work
IMAGE           ?= /srv/www/wiki.musl-libc.org

all: $(addprefix $(WORK)/,$(addsuffix .html,$(basename $(shell cd $(SRCDIR) && find -type f -name '*.md'))))
all: $(addprefix $(WORK)/,$(addsuffix .min.css,$(basename $(shell cd $(SRCDIR) && find -type f -name '*.css' -and -not -name '*.min.css'))))
all: $(addprefix $(WORK)/,$(shell cd $(SRCDIR) && find -type f -name '*.png' -or -name '*.ico' -or -name '*.conf'))
clean:
	find $(WORK) -type f -name '*.html' -delete -print
	find $(WORK) -type f -name '*.min.css' -delete -print
	find $(WORK) -type f -name '*.tmp' -delete -print

lint:
	@find $(SRCDIR) -type f -name '*.md' -and -not -name 'bugs-found-by-musl.md' -print0 | xargs -t0 mdl -s "$(SRCDIR)/.mdlstyle.rb"

install:
	- gem install mdl
	- npm install -g postcss-cli cssnano autoprefixer

$(WORK)/%.conf: $(SRCDIR)/%.conf
	cp "$<" "$@"

$(WORK)/%.png: $(SRCDIR)/%.png
	cp "$<" "$@"

$(WORK)/%.ico: $(SRCDIR)/%.ico
	cp "$<" "$@"

# cssnano is ran separately because it likes to take out vendor prefixes we might still need
$(WORK)/%.min.css: $(SRCDIR)/%.css
	postcss "$<" -u cssnano -o "$(WORK)/$*.css.tmp"
	postcss "$(WORK)/$*.css.tmp" -u autoprefixer -o "$@"
	rm -f "$(WORK)/$*.css.tmp"

$(WORK)/%.html: $(SRCDIR)/%.md $(shell $(SRCDIR)/scripts/markdown.sh --template "$<" "$@")
	mkdir -p $(dir $@)
	$(SRCDIR)/scripts/markdown.sh "$<" "$@"
	tidy -w 0 -utf8 -language en -i -m --show-info no "$@"

watch:
	while true; do \
	    { find $(SRCDIR) -not -name '*.min.css' -and -not -name '*.tmp' -and -not -name '*.html' -and -not -path '*/.*'; } | entr -c sh -c '$(MAKE) WORK=$(WORK) lint && $(MAKE) WORK=$(WORK)'; \
	done

deploy: all
	rsync -v -rl --delete-after $(WORK)/ "$(IMAGE)" --exclude '*.git*'

.PHONY: all clean deploy lint watch
