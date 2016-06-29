# don't lint bugs-found-by-musl.md due to intentionally long line length
lint:
	find -type f -and -not -name 'bugs-found-by-musl.md' -and -name '*.md' -print0 | xargs -0 mdl -s .mdlstyle.rb

