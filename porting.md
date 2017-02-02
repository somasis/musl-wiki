# Porting

resources describing a musl port to a new architecture

<http://brightrain.aerifal.cx/~niklata/PORTING>

<http://www.openwall.com/lists/musl/2012/07/08/1>

[commit introducing a new C-based crt framework][commit-crt], which makes
writing arch-specific startup-code much simpler.

[commit of the or1k port][commit-or1k], which shows the porting work
required for a new arch.

the unsquashed history of the powerpc port has been archived @
<https://github.com/rofl0r/musl-ppc> (branch ppc)

the unsquashed history of the x32 port has been archived @
<https://github.com/rofl0r/musl> (branch x32g)

[AArch64][Porting/AArch64] porting page.

use the [libc-test] testsuite to test your port.

[commit-crt]: http://git.musl-libc.org/cgit/musl/commit/?id=c5e34dabbb47d8e97a4deccbb421e0cd93c0094b
[commit-or1k]: http://git.musl-libc.org/cgit/musl/commit/?id=200d15479c0bc48471ee7b8e538ce33af990f82e
