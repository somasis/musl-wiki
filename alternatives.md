# Alternatives

Resource list for alternative libraries and programs that are lightweight, not
bloated, efficient or have other useful design characteristics and may be
useable with musl.

# Alternative Libraries and Programs

- [pkgconf] Drop in replacement for pkg-config with no circular dependencies.
  Does not require glib.
- [netbsd-curses] Drop in replacement for ncurses and ncursesw, ported from
  netbsd. considerably smaller than ncurses.
- [mlibtool] Drop-in replacement for libtool. can speed up builds significantly
  as it's written in C.
- [cDetect] C replacement for feature detection generally provided by utilities
  like GNU autotools.
- [freeglut] Replacement for glut.
- [libutf] utf8 library (note that by using musl, UTF8 support is automatically
  enabled. no need to use any 3rd party library)
- [gettext-tiny] gettext replacement. Provides a no-op implementation for
  libintl, and several no-op gettext utilities. Working msgfmt program.
- [gettext-stub] Provides a stub replacement for libintl.
- [libdrpc] Port of RPC based on Android's libdrpc. Replaces parts of older
  glibc RPC functionality and/or libtirpc.
- [libsep] Minimal RPC library to assist compartmentalisation of small
  applications.
- [minised] Faster but limited earlier version of sed. (note that busybox
  1.20.2's sed implementation is 100% POSIX compatible and feature-complete)
- [ignite] init replacement, works with runit.
- [linenoise] lightweight readline replacement.
- [libedit] drop-in replacement for readline
  ([needs a handful of symlinks][libedit-symlinks]). about 30% less code.
  lacks some rare functions but is compatible with a number of readline users
  like gdb.
- ~~[termbox] alternative to ncurses for simple terminal apps. 16 colors only.
  very small, clean, well designed code.~~ only up to commit [66c3f91b]
- [tinyalsa] alternative to alsalib (interfacing with kernel's alsa API).
- [libnl-tiny] drop-in replacement for netlink (libnl 1.2). may need some
  [compatibility CFLAGS].
- [uuterm] slim terminal emulator written by musl's author.
- [udhcpc] small DHCP client, part of Busybox. use these [two][udhcpc-two]
  [scripts][udhcpc-scripts] to operate it.
- [ndhc] small DHCP client, focus on security.
- [ubus] replacement for dbus and general-purpose IPC protocol using simple unix
  domain sockets. does not require running a daemon.
- [mandoc] alternative to massively bloated groff and accompanying manpage
  implementation.
- [moe] A powerful and user-friendly console text editor (alternative to GNU
  Nano and Joe), but written in C++...
- [textadept] Highly configurable and customizable text editor written in C (and
  lua) and based on Scintilla editor widget. Terminal version works with ncurses
  or pdcurses. Also check out Scinterm, the ncurses based version of the
  Scintilla editor component.
- [slock] minimalist alternative to xlock and xlockmore.
- [star] Alternative to GNU tar.
- [uSTL] replacement for the C++ STL (Standard Template Library).

[pkgconf]: https://github.com/pkgconf/pkgconf
[netbsd-curses]: https://github.com/sabotage-linux/netbsd-curses
[mlibtool]: https://github.com/GregorR/mlibtool
[cDetect]: http://sourceforge.net/projects/cdetect/
[freeglut]: http://freeglut.sourceforge.net/
[libutf]: https://github.com/cls/libutf
[gettext-tiny]: https://github.com/sabotage-linux/gettext-tiny
[gettext-stub]: http://penma.de/code/gettext-stub/
[libdrpc]: https://github.com/idunham/libdrpc
[libsep]: https://github.com/marinosi/libsep
[minised]: http://www.exactcode.com/site/open_source/minised/
[ignite]: https://github.com/chneukirchen/ignite
[linenoise]: https://github.com/antirez/linenoise
[libedit]: http://www.thrysoee.dk/editline/
[libedit-symlinks]: https://github.com/sabotage-linux/sabotage/blob/master/pkg/libedit#L19
[termbox]: https://github.com/nsf/termbox
[66c3f91b]: https://github.com/nsf/termbox/commit/66c3f91b14e24510319bce6b5cc2fecf8cf5abff#commitcomment-3790714
[tinyalsa]: https://github.com/tinyalsa/tinyalsa
[libnl-tiny]: https://github.com/sabotage-linux/libnl-tiny
[compatibility CFLAGS]: https://github.com/sabotage-linux/sabotage/blob/master/pkg/wpa-supplicant#L20
[uuterm]: http://git.musl-libc.org/cgit/uuterm/
[udhcpc]: http://en.wikipedia.org/wiki/Udhcpc
[udhcpc-two]: https://github.com/sabotage-linux/sabotage/blob/master/KEEP/etc/udhcpc-script
[udhcpc-scripts]: https://github.com/sabotage-linux/sabotage/blob/master/KEEP/bin/dhclient
[ndhc]: https://code.google.com/p/ndhcp/
[ubus]: http://www.unixbus.org/ubus/
[mandoc]: http://mdocml.bsd.lv/
[moe]: http://gnu.org/software/moe
[textadept]: http://foicica.com/textadept/
[slock]: http://tools.suckless.org/slock
[star]: http://freecode.com/projects/star
[uSTL]: https://github.com/msharov/ustl

## Compression/Decompression

- [sortix libz] cleaned up, modern fork of zlib.
- [libarchive] bsdtar offers a replacement for gnu tar.
- [Lzip] family of data compressors based on the LZMA algorithm. See [Benchmark],
  and [Quality-assurance].
- [XZ Embedded] small xz decompressor library.
- [lzo] very fast compression library.
- [gzfile.c] C routines to read gzipped files.
- [miniz] Single C source file Deflate/Inflate compression library with
  zlib-compatible API, ZIP archive reading/writing, PNG writing.
- [flate] small gzip compatible compressor lib
- [lz4][lz4-fast] extremely fast (BSD-licensed) compression algo
- [lz4][lz4-small] alternate lz4 impl (BSD-licensed), even smaller
- [basic compression library] non-bloated (zlib-licensed) impl of several basic
  compression algorithms.

[Large Text Compression Benchmark](http://mattmahoney.net/dc/text.html)

[sortix libz]: https://sortix.org/libz/
[libarchive]: http://www.libarchive.org/
[Lzip]: http://lzip.nongnu.org/lzip.html
[XZ Embedded]: http://tukaani.org/xz/embedded.html
[lzo]: http://www.oberhumer.com/opensource/lzo/
[gzfile.c]: http://wizard.ae.krakow.pl/~jb/gzfile/
[miniz]: http://code.google.com/p/miniz/
[flate]: http://git.suckless.org/flate
[lz4-fast]: https://github.com/Cyan4973/lz4
[lz4-small]: https://github.com/htruong/lz4
[basic compression library]: http://bcl.comli.eu/home-en.html

## Crypto

- [TweetNaCl] tiny, fully NaCl-compatible high-security crypto C library (single
  C file)
- [libtomcrypt] public domain crypto library
- [kripto] lightweight crypto library written in ISO C99. WIP.
- [libsodium] encryption/decryption library
- [tropicssl] ssl library (BSD) - unmaintained and lacking a few patches for
  recent vulnerabilities found in PolarSSL.
- [polarssl] ssl library (GPL) - commercialised and relicensed fork of
  tropicssl.
- [cyassl] ssl library (GPL)
- [axtls] ssl library (BSD license)
- [selene] ssl/tls library (Apache license)
- [dropbear] replacement for OpenSSH.
- [LibreSSL] drop-in replacement for (and fork of) OpenSSL.

[TweetNaCl]: http://tweetnacl.cr.yp.to/
[libtomcrypt]: https://github.com/libtom/libtomcrypt
[kripto]: https://github.com/lightbit/kripto
[libsodium]: https://github.com/jedisct1/libsodium
[tropicssl]: http://gitorious.org/tropicssl
[polarssl]: https://polarssl.org/
[cyassl]: http://yassl.com/yaSSL/Home.html
[axtls]: http://axtls.sourceforge.net/
[selene]: https://github.com/pquerna/selene
[dropbear]: https://matt.ucc.asn.au/dropbear/dropbear.html
[LibreSSL]: http://www.libressl.org/

## Databases

- [tinyCDB] small constant database library. perl wrappers are available on
  CPAN.
- [LMDB] high-performance, mmap'd key-value store used in the OpenLDAP project.

[tinyCDB]: http://www.corpit.ru/mjt/tinycdb.html
[LMDB]: http://symas.com/mdb/

## Graphics

- [Agar] MIT-licensed, lightweight GUI toolkit lib written in C
- [iup] lighweight and portable GUI toolkit written in C, has lua bindings
- [mtk] lightweight gui library written in C. currently writes directly to
  videomem of the milkymist open source hardware platform. requires port to
  X/SDL/FB.
- [GraphApp] Toolkit for platform-independent graphical user interface
  programming in the C language.
- [m2tklib] Mini Interative Interface Toolkit Library - a portable graphical and
  character user interface (GUI+CUI) library for embedded systems.
- [ftk] GUI library for embedded systems.
- [SVG library]
- [SDL_svg library]
- [pnglite]
- [simple-png]
- [lodepng] single-file implementation to read png files. requires zlib.
- [picojpeg]
- [SOIL] Simple OpenGL Image Library
- [gleri] opengl implementation for remote GL usage.
- [TinyGL] opengl implementation with software rendering. needs some fixes to
  work on 64bit archs.

[Agar]: http://libagar.org/
[iup]: http://www.tecgraf.puc-rio.br/iup/
[mtk]: https://github.com/milkymist/mtk
[milkymist]: http://milkymist.org/3/
[GraphApp]: http://enchantia.com/software/graphapp/index.html
[m2tklib]: https://code.google.com/p/m2tklib/
[ftk]: https://code.google.com/p/ftk/
[SVG library]: http://www.netsurf-browser.org/projects/libsvgtiny/
[SDL_svg library]: http://www.linuxmotors.com/SDL_svg/
[pnglite]: http://sourceforge.net/projects/pnglite/files/
[simple-png]: https://code.google.com/p/simple-png/
[lodepng]: http://lodev.org/lodepng/
[picojpeg]: https://code.google.com/p/picojpeg/
[SOIL]: http://lonesock.net/soil.html
[gleri]: https://github.com/msharov/gleri
[TinyGL]: http://bellard.org/TinyGL/

## Video

- [mpv] video player forked from mplayer2 with tons of junk removed. builds in
  seconds.

[mpv]: http://mpv.io/

## X11 alternatives

- [tinyxlib]
- [nano-x]
- [directfb]

[tinyxlib]: https://github.com/idunham/tinyxlib
[nano-x]: http://www.microwindows.org/
[directfb]: http://directfb.org/

## Compilers/preprocessors

- [ucpp] C99 preprocessor library and program.
- [mcpp] another C99 preprocessor library and program.
- [sparse] mostly C99 compatible semantic analyser and C frontend written by
  linus.
- [firm/cparser] C99 compatible C compiler and optimization framework. x86 and
  SPARC backends.
- [GPP] General Purpose Preprocessor. Has added functionality not available in a
  standard C preprocessor. Can be used as a preprocessor or working with
  templates.
- [vbcc] mostly C99 compatible C compiler. open source but non-free LICENSE.

[ucpp]: http://code.google.com/p/ucpp/
[mcpp]: http://mcpp.sourceforge.net/
[sparse]: https://git.kernel.org/cgit/devel/sparse/sparse.git/
[firm/cparser]: http://pp.info.uni-karlsruhe.de/firm/
[GPP]: http://en.nothingisreal.com/wiki/GPP
[vbcc]: https://github.com/kusma/vbcc

## Scripting languages

- [Lua] is a full-fledged small embeddable as well as standalone language.
  Pretty popular, but some semantic choices may make conscious programmer
  cringe: accessing non-existent (mistyped) variable returns legitimate value,
  array indexes start from 1, etc.
- [Squirrel] is embeddable language with C-like syntax and minimal number of
  syntax/semantics idiosyncrasies. Uses reference counting. Core builds to
  ~250KB for i386. uses C++ though.
    - [General-Purpose Squirrel] - fork to make a standalone general-purpose
      language out of Squirrel core, without compromising on lightweightedness.
- [jim] embedded tcl scripting engine in Ansi C. compiles to 100-200KB depending
  on featureset.
- [TinyJS] An extremely simple (~2000 line) JavaScript interpreter.
- [42TinyJS] Fork of TinyJS with more functionality.
- [Quad-Wheel] Small but full-ecma-262 supported javascript engine, written in
  ansi C.
- [tinypy] Minimalist implementation of python in 64k of code.

[Lua]: http://www.lua.org/
[Squirrel]: http://squirrel-lang.org/
[General-Purpose Squirrel]: https://github.com/pfalcon/squirrel-modules
[jim]: http://jim.tcl.tk/
[TinyJS]: http://code.google.com/p/tiny-js/
[42TinyJS]: https://code.google.com/p/42tiny-js/
[Quad-Wheel]: http://code.google.com/p/quad-wheel/
[tinypy]: http://www.tinypy.org/

## PDF

- [mupdf] Lightweight PDF viewer.
- [Poppler versus mupdf]

[mupdf]: http://www.mupdf.com/
[Poppler versus mupdf]: http://hzqtc.github.io/2012/04/poppler-vs-mupdf.html

## Regular Expressions

Musl's regular expressions pattern matching routines are based on the [TRE]
library. The Musl version of the code contains at least two bug fixes that were
never fixed in the original code. For file pattern matching (fnmatch), musl uses
an implementation based on the "Sea of Stars" algorithm.

Comparing Perl regular expressions implementations to Regex implementations
shows pattern matching performance for various cases, but it can be like
comparing apples to oranges. Perl regular expression pattern matching is not
equivalent to a regular langauge which can be solved by a finite state automata.
Some regex extensions also may not be compliant with the definition of a formal
regular language.

- [Regular Expression Matching Can Be Simple And Fast] One comparison between
  regex and Perl regular expressions.
- [Regex Benchmark] Compares various regular expression methods' performances.
- [PCRE performance] Comparison of PCRE JIT with other regular expression
  methods' performances. Older performance comparisons don't typically include
  PCRE JIT which has better performance than standard PCRE. They just use
  standard PCRE.

[TRE]: http://laurikari.net/tre/
[Regular Expression Matching Can Be Simple And Fast]: http://swtch.com/~rsc/regexp/regexp1.html
[Regex Benchmark]: http://lh3lh3.users.sourceforge.net/reb.shtml
[PCRE performance]: http://sljit.sourceforge.net/pcre.html

# Code Collections and Basic Libraries/Programs

- [Toybox]
- [Busybox]
- [Heirloom Project]
- [picobsd]
- [obase] Port of OpenBSD userland to Linux
- [noXCUse] New Open XCU Simple Edition; or, No Excuse for bloat and brokenness:
  a set of unix utilities developed by musl's author.
- [pikhq-coreutils] a (small) set of unix utilities.
- [hardcore-utils] a (small) set of unix utilities.
- [sbase] portable set of suckless unix utilities
- [ubase] linux-specific set of suckless unix utilities (util-linux replacement)
- [lazy-utils] a (small) set of unix utilities to complement toybox
- [usul] From the main developer of sbase. non-POSIX tabular Unix utilities.
- [lit cave] Has a lot of lightweight replacement programs, including a troff
  implementation, utilities using framebuffer and a C compiler.
- [elks] The elks tarball includes a collection ("elkscmd") of very lightweight
  standard unix programs, taken from minix and other sources. Also includes
  lightweight man alternative (bugfixed version is included in hardcore-utils).
- [Skarnet software] Various utilities.
- [Bizarre Sources] Init replacement and other small programs.

[Toybox]: http://landley.net/toybox
[Busybox]: http://www.busybox.net/
[Heirloom Project]: http://heirloom.sourceforge.net/
[picobsd]: http://code.google.com/p/freebsd-head/source/browse/release/?r=bbfa6f219c41b6850ef0e7699f439ad5488435ae#release%2Fpicobsd
[obase]: https://github.com/chneukirchen/obase
[noXCUse]: http://git.musl-libc.org/cgit/noxcuse/tree/
[pikhq-coreutils]: https://github.com/pikhq/pikhq-coreutils
[hardcore-utils]: https://github.com/rofl0r/hardcore-utils
[sbase]: http://git.suckless.org/sbase
[ubase]: http://git.suckless.org/ubase
[lazy-utils]: https://github.com/dimkr/lazy-utils
[usul]: http://lubutu.com/soso/usul
[lit cave]: http://litcave.rudi.ir/
[elks]: http://elks.sourceforge.net/
[Skarnet software]: http://skarnet.org/software/
[Bizarre Sources]: http://www.energymech.net/users/proton/

# General Suggestions/Recommendations

- [Stuff that rocks] Suckless.org recommendations on libraries they prefer.
- [Harmful software] More recommendations from suckless.org and plan 9 for
  libraries to avoid and what to replace them with.
- [Puppy Linux forum thread on Unbloated resources]
- [choosing an ssl library]
- [BusyBox tiny utility recommendations]
- [Unbloated resources in C] \(beware of stb* from nothings.org since author is
  ignorant about invoking UB\)
- [embutils]
- [MinGW Useful links] I realize the page is for MinGW, but it has several
  cross-platform library recommendations including a large list of GUIs. It's
  easier to refer to that page than to try to maintain two sets of library lists
  (here and at the MinGW wiki) for certain categories.

[Stuff that rocks]: http://suckless.org/rocks
[Harmful software]: http://harmful.cat-v.org/software/
[Puppy Linux forum thread on Unbloated resources]: http://www.murga-linux.com/puppy/viewtopic.php?t=72359
[Unbloated resources in C]: http://bashismal.blogspot.com/2011/10/unbloated-resources-in-c.html
[choosing an ssl library]: http://teholabs.com/?p=445
[BusyBox tiny utility recommendations]: http://busybox.net/tinyutils.html
[embutils]: http://www.fefe.de/embutils/
[MinGW Useful links]: http://www.mingw.org/wiki/Community_Supplied_Links

