# musl-wiki

[![Travis](https://img.shields.io/travis/somasis/musl-wiki.svg?maxAge=2592000?style=flat-square)](https://travis-ci.org/somasis/musl-wiki)

A community-maintained wiki detailing things such as implementation details,
frequently asked questions, open issues, users of musl, and other information to
the [musl libc](https://www.musl-libc.org/) project.

## Contributing

[Pull requests](https://github.com/somasis/musl-wiki/pulls) are welcomed.

Rather than taking edits from anonymous users and allowing drive-by
contributions, this wiki takes edits through the git repo here, in order to
ensure that all documentation and information on the wiki is verified to be
correct and reasonably good quality.

When making edits for submission, may want to run `make lint` in order to ensure
that your newly-added documentation or edits are adherant to the markdown
style. You can also run a local copy of the wiki with `make serve`. This will
run the wiki on 127.0.0.1:4567 by default. However, it's not really necessary to
test locally; Travis CI tests all pull-requests and runs lint on them, and fails
if the new commits introduce warnings.

If you're not sure if you have the deps needed for testing locally, just run
`make install` and it should take care of it.

