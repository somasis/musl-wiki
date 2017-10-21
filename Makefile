# build requirements:
#     discount `markdown` (http://www.pell.portland.or.us/~orc/Code/discount/)
#     tidy-html5 (https://github.com/htacg/tidy-html5)
#     postcss-cli (https://www.npmjs.com/package/postcss-cli)
#     cssnano (https://www.npmjs.com/package/cssnano)
#     autoprefixer (https://www.npmjs.com/package/autoprefixer)
#
# `check` requirements:
#     markdownlint (https://github.com/markdownlint/markdownlint)
#
# `check-links` requirements:
#     devd (https://github.com/cortesi/devd)
#     linkchecker (https://wummel.github.io/linkchecker)
#

SRCDIR          := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
WORK            ?= ./work
WORK            := $(abspath $(WORK))

IMAGE           ?= /srv/www/wiki.musl-libc.org

HTML            = $(addprefix $(WORK)/,$(addsuffix .html,$(basename $(shell cd $(SRCDIR) && find \( -type f -or -type l \) -and \( -name '*.md' \) -and -not \( -path './work/*' -or -path '$(WORK)/*' -or -path '*/.*/*' \) -prune))))
CSS             = $(addprefix $(WORK)/,$(addsuffix .min.css,$(basename $(shell cd $(SRCDIR) && find \( -type f -or -type l \) -and \( -name '*.css' -and -not -name '*.min.css' \) -and -not \( -path './work/*' -or -path '$(WORK)/*' -or -path '*/.*/*' \) -prune))))
AUX             = $(addprefix $(WORK)/,$(shell cd $(SRCDIR) && find \( -type f -or -type l \) -and \( -name '*.png' -or -name '*.ico' -or -name '*.conf' \) -and -not \( -path './work/*' -or -path '$(WORK)/*' -or -path '*/.*/*' \) -prune))

all: $(HTML) $(CSS) $(AUX)
clean:
	rm -f $(HTML)
	rm -f $(CSS)
	rm -f $(AUX)
	rm -f $(WORK)/devd.*
	-find $(WORK) -type d -empty -print -delete

check: lint

lint: all
	find $(SRCDIR) -type f -name '*.md' -and -not -name 'bugs-found-by-musl.md' -print0 | xargs -t0 mdl -s "$(SRCDIR)/.mdlstyle.rb"

check-links: all
	$(SRCDIR)/scripts/devd.sh "$(WORK)"
	$(SRCDIR)/scripts/linkchecker.sh "$(WORK)" "$$(cat $(WORK)/devd.address)"

install:
	gem install mdl
	$(TRAVIS_SUDO) npm install -g postcss-cli cssnano autoprefixer

# cssnano is ran separately because it likes to take out vendor prefixes we might still need
$(WORK)/%.min.css: $(SRCDIR)/%.css
	postcss "$<" -u cssnano -o "$(WORK)/$*.css.tmp"
	postcss "$(WORK)/$*.css.tmp" -u autoprefixer -o "$@"
	rm -f "$(WORK)/$*.css.tmp"

$(WORK)/%.html: $(SRCDIR)/%.md $(shell $(SRCDIR)/scripts/markdown.sh --template "$<" "$@")
	mkdir -p $(dir $@)
	$(SRCDIR)/scripts/markdown.sh "$<" "$@"
	tidy -w 0 -utf8 -language en -i -m --show-info no "$@"

$(WORK)/%: $(SRCDIR)/%
	cp -f "$<" "$@"

watch:
	while true; do \
	    { find $(SRCDIR) -not -name '*.min.css' -and -not -name '*.tmp' -and -not -name '*.html' -and -not -path '*/.*'; } | entr -c sh -c '$(MAKE) WORK=$(WORK) lint && $(MAKE) WORK=$(WORK)'; \
	done

deploy: all
	rsync -v -rl --delete-after $(WORK)/ "$(IMAGE)" --exclude '*.git*'

.PHONY: check lint check-links install clean watch deploy

