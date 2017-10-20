# libc-test

[libc-test] is a continuation of the original [libc-testsuite], maintained by
Szabolcs Nagy, the author of musl's math library. at this point, it covers
everything that was in the original libc-testsuite plus a lot more, including
regression tests for bugs that were fixed in musl.

it is expected that some tests fail at the moment. these are tests for optional
POSIX/XSI features that are currently not implemented (causing build errors),
plus a handful of math tests were the libm math functions fail to provide the
required level of exactness (these usually print a hint that the error is
expected). all of the other tests should always pass, including all tests in
src/functional and src/regression.

automatically synced git mirror: <git://repo.or.cz/libc-test>

[libc-test]: http://nsz.repo.hu/git/?p=libc-test
[libc-testsuite]: http://git.musl-libc.org/cgit/libc-testsuite/

