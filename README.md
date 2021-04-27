# musl-wiki

[![CI](https://github.com/somasis/musl-wiki/actions/workflows/main.yml/badge.svg)](https://github.com/somasis/musl-wiki/actions/workflows/main.yml)
[![Website status](https://img.shields.io/website-up-down-green-red/http/shields.io.svg?style=flat-square)](https://wiki.musl-libc.org)

A community-maintained wiki detailing things such as implementation details,
frequently asked questions, open issues, users of musl, and other information to
the [musl libc](https://www.musl-libc.org/) project.

## Cloning

Make sure to get the `makedown` submodule, you'll need it to make the HTML.

```sh
git clone --recursive https://github.com/somasis/musl-wiki
```

Make sure to look at [makedown]'s requirements for building and testing.

[makedown]: https://github.com/somasis/makedown

## Contributing

[Pull requests](https://github.com/somasis/musl-wiki/pulls) are welcomed.

Rather than taking edits from anonymous users and allowing drive-by
contributions, this wiki takes edits through the git repo here, in order to
ensure that all documentation and information on the wiki is verified to be
correct and reasonably good quality.

When making edits for submission, you may want to run `make lint` in order to ensure
that your newly-added documentation or edits are adherent to the markdown
style. However, it's not really necessary to test locally; Travis CI tests all
pull-requests and runs `lint` on them, and fails if the new commits introduce warnings.

In addition to editing locally, you can also edit online.
For creating new pages, click GitHub's "Create New File" button, type the page
filename (so, \<filename\>.md), and begin editing there. You can also edit pages
the same way by clicking a page (the filenames correspond to the page titles) and
clicking the edit icon next to history.

