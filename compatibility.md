# Compatibility

Compatibility of the interfaces provided by musl with existing standards and
software packages.

## Standards compatibility tables

- [POSIX 2008 API coverage][POSIX2008] (obsolete STREAMS and posix_trace APIs
  are not included)
- [C99 API coverage][C99]
- [C11 API coverage][C11] (optional annex K is not included)

[POSIX2008]: http://repo.or.cz/w/musl-tools.git/blob_plain/HEAD:/tab_posix.html
[C99]: http://repo.or.cz/w/musl-tools.git/blob_plain/HEAD:/tab_c99.html
[C11]: http://repo.or.cz/w/musl-tools.git/blob_plain/HEAD:/tab_c11.html

## Compatibility with other implementations

- [[Functional differences from glibc]]
- [Comparison] with other Linux libc implementations.

[Comparison]: https://www.etalabs.net/compare_libcs.html

## Software compatibility, patches and build instructions

- pkgsrc based software compatibility table:
    - ~~[[Pkgsrc results]] (warning: very large wiki page, renders slowly)~~ Outdated.
    - pkgsrc results are archived at <http://musl.codu.org>.
    - The necessary patches are at [musl-pkgsrc-patches (hg)] or
      [musl-pkgsrc-patches (git)].
- Build instructions and patches for various software packages:
    - [sabotage recipes], [patches][sabotage patches]
    - [LightCube packages]
    - [Dragora recipes], [patches][Dragora patches]
    - [Alpine ports]
    - [Gentoo overlay with musl support]
    - See the packaging work in various other
      [[distributions|Projects using musl#linux-distributions-using-musl]].

[musl-pkgsrc-patches (hg)]: http://bitbucket.org/GregorR/musl-pkgsrc-patches
[musl-pkgsrc-patches (git)]: https://github.com/GregorR/musl-pkgsrc-patches
[sabotage recipes]: http://github.com/sabotage-linux/sabotage/tree/master/pkg
[sabotage patches]: http://github.com/sabotage-linux/sabotage/tree/master/KEEP
[LightCube packages]: https://github.com/jhuntwork/lightcube-bootstrap-musl/tree/master/packages
[Dragora recipes]: http://git.savannah.gnu.org/cgit/dragora.git/tree/recipes
[Dragora patches]: http://git.savannah.gnu.org/cgit/dragora.git/tree/patches
[Alpine ports]: http://git.alpinelinux.org/cgit/aports/tree/main/
[Gentoo overlay with musl support]: http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-dev.git;a=shortlog;h=refs/heads/musl

