PAGES ?= wiki

# don't lint bugs-found-by-musl.md due to intentionally long line length
lint:
	find $(PAGES) -type f -and -not -name 'bugs-found-by-musl.md' -and -not -name '_*' -and -name '*.md' -print0 | xargs -0 mdl -s .mdlstyle.rb

serve:
	gollum --h1-title --user-icons gravatar --no-edit --no-live-preview --host 127.0.0.1 --css --page-file-dir $(PAGES)
