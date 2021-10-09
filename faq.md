# FAQ

# Q: lib(m|pthread|crypt).a/so are empty?

Yes, this is by design. musl puts everything into libc.a/so to avoid memory
bloat. The empty files are only there for compatibility reasons. The official
explanation: <http://openwall.com/lists/musl/2012/07/25/3>
more info: [Design Concepts]

# Q: Why is there no `__MUSL__` macro?

It's a bug to assume a certain implementation has particular properties rather
than testing. So far, every time somebody's asked for this with a particular
usage case in mind, the usage case was badly wrong, and would have broken
support for the next release of musl. The official explanation:
<http://openwall.com/lists/musl/2013/03/29/13>

# Q: Where is `ldd`?

musl's dynamic linker comes with ldd functionality built in. It can be as easy as
creating a symlink from ld-musl-$ARCH.so to /bin/ldd, however the recommended way
is to create a shell script or program that extracts the interpreter from the binary
(e.g. using `readelf -l`) and invoking it with the `--list` option e.g.:
`/lib/ld-musl-x86_64.so.1 --list /bin/yasm`.

# Q: Where is `ldconfig`?

There isn't one. You can specify the library search path by creating or editing
the file `/etc/ld-musl-$ARCH.path`, where `$ARCH` is the string identifying your
architecture (look at what `/lib/ld-musl-*.so.1` uses if uncertain).  Paths can
be separated by newlines or colons. The environment variables `LD_PRELOAD` and
`LD_LIBRARY_PATH` are also supported for one-off cases.

# Q: Why is `sys/queue.h` not included?

sys/queue.h is a full library implemented in a header file, and there's no
reason for it to be part of libc; the file is completely self-contained and
independent. musl aims not to have code/significant, copyrightable content in
public header files (i.e. significant content that's not straight interface
definitions)

# Q: Why is `fts.h` not included?

It's impossible to match the glibc ABI for fts because the glibc ABI is
unusably broken. This also means that no working software can be built using
the built-in fts from glibc; anything using fts is either already including its
own copy (there is a canonical BSD version and gnulib has it too), or is
hopelessly broken on glibc and the maintainers are just unaware of that fact. So
including it in musl would not help anything at this time. If glibc bug 15838 is
fixed by adding an fts64 interface in glibc, we could consider supporting it
with a matching ABI in musl, but it seems more likely that glibc will just
deprecate this interface.

# Q: Do I need to define `_LARGEFILE64_SOURCE` to get 64bit `off_t`?

- Those options are for building apps, not building libc.
- `-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE` have nothing to do with supporting
  large files properly but with exposing the idiotic legacy interfaces with 64
  on the end of their names (like open64, lseek64, etc.). only
  `-D_FILE_OFFSET_BITS=64` should ever be used, anywhere, even on glibc.
- under musl, `off_t` is always 64-bit. the `-D_LARGEFILE64_SOURCE` option is
  however honored to support compiling applications using the legacy open64,
  etc. nonsense, but it just #defines them away to the version without 64 on the
  end.

note that if you're building a whole system with musl you never need any of
them. you don't need them for building musl, and you don't need them for
building apps against musl (but they won't hurt, generally, either).

# Q: Why am I getting "error: redefinition of struct ethhdr/tcphdr/etc"?

The application you're trying to compile mixes userspace and kernel headers
(/include/linux). The kernel headers are notoriously broken for userspace and
clash with the definitions provided by musl. It only works (in certain cases)
with GLIBC because...

- the userspace headers just include the kernel headers, and
- because the kernel headers have a hardcoded compatibility fix for GLIBC to
  prevent exactly this issue (`linux/libc_compat.h`)

the issue can be fixed in different ways:

- remove the linux/ include directives
- use the [patched kernel-headers package from sabotage linux][patched-headers]
- factor out the code needing the kernel headers into a separate compilation
  unit which doesn't use any userspace headers
- copy the required struct definitions into an internal header and rename them.

[patched-headers]: https://github.com/sabotage-linux/kernel-headers

# Q: Why is the utmp/wtmp functionality only implemented as stubs?

- if the feature is implemented, you need to take additional measures to protect
  your user's privacy
- in order to use the utmp/wtmp feature, you need a suid/sgid binary to modify
  the database, which opens the door for security issues:
- if you compromise those binaries, you can inject arbitrary data into the db,
  that other programs might interpret in exploitable ways
- that's a HUGE risk to pay for the sake of a basically-useless and
  possibly-harmful "feature"

# Q: My dynamically linked program crashes on PowerPC!

Make sure you pass `-Wl,--secure-plt` when you use dynamic linking. Musl only
supports the secure plt. To check if your binary is correct, use `readelf -a
a.out | grep PPC_GOT`. It should list at least one line. There's also a known bug
in binutils 2.22: <http://sourceware.org/bugzilla/show_bug.cgi?id=13470> Be sure
to use the patches attached there. in order to test for this issue, create a
small test program that uses environ:

```c
#include <stdio.h>
extern char** environ; int main() {dprintf(2, "%p\n", environ);}
```

If that crashes, despite having `PPC_GOT` entries, you are affected. Further, you
should build gcc with the option `--with-long-double-64 --enable-secureplt`.
Additionally use [this patch].

[this patch]: https://raw.github.com/rofl0r/sabotage/master/KEEP/gcc-454-stackend.patch

# Q: Busybox linked against musl segfaults on ARM!

The bug is probably [`--sort-section` renders busybox unusable on ARM][busybox-arm].

Use this fix: `sed -i 's,SORT_SECTION=,SORT_SECTION= #,' scripts/trylink`

[busybox-arm]: http://sourceware.org/bugzilla/show_bug.cgi?id=14156

# Q: When compiling something against musl, I get error messages about `sys/cdefs.h`

Congratulations, you have found a bug! The bug is in the application that uses
this internal glibc header. This header is *not* intended to be used by any
program. File a bug report. Until it gets fixed, patch the program to remove the
include line and replace all occurrences of:

```c
__BEGIN_DECLS
```

with

```c
#ifdef __cplusplus
extern "C" {
#endif
```

and all occurrences of

```c
__END_DECLS
```

with

```c
#ifdef __cplusplus
}
#endif
```

# Q: I'm trying to compile something against musl and I get lots of error messages!

musl is strict about namespaces. As a quick fix, add to your CFLAGS
`-D_GNU_SOURCE` for GNU- and Linux-specific functions like strndup, and add
`-D_BSD_SOURCE` for BSD-specific functions like strlcpy. If you are the
maintainer of the package, consider determining the correct namespace and
adding it to the relevant .c files. [Article about feature test macros on
lwn.net][feature-test-macros].

[feature-test-macros]: https://lwn.net/Articles/590381/

# Q: Building musl fails with internal compiler error in `src/complex/__cexp.c`

Some versions of gcc fail to compile the cpack compound literal used in the
complex code, the quick fix is to remove src/complex (it will remove complex
math support).

# Q: Application XY misbehaves or crashes at runtime when linked against musl

Usually this is because the app has hardcoded glibc-specific assumptions or
wrong #ifdefs. See [Functional differences from glibc]. The most common causes
are expectations of gnu getopt behaviour, iconv usage on UCS2 with assumptions
that BOM is processed and the byte order detected, assuming that `off_t` is 32
bit, and assumptions that `pthread_create` will create sufficiently large stacks
by default (crash situation). A good approach to solving the issue is to watch
out for #if and #ifdefs in the code and placing some debug #warning there to see
which code paths are enabled by the preprocessor. Often the logic taken by
`#ifdef`'s is to check a blacklist of preprocessor defines `#if __sun__ ||
__haiku__ || __irix__ || __qnx__ portable_code(); #else glibc_code() #endif`.
The logic should be the other way round:
`#ifndef __GLIBC__ portable_code() #else glibc_code()`. There's also no point
in checking `__GLIBC__` version numbers without first making sure that
`__GLIBC__` is defined at all.

# Q: I'm getting a gnulib error

```text
freadahead.c:87:3: error: #error "Please port gnulib freadahead.c to your platform!
Look at the definition of fflush, fread, ungetc on your system, then report this to bug-gnulib."
```

Congratulations, you have just encountered [gnulib], the GNU "portability"
library! The special "appeal" of this "portability" library is that it has been
copied into the source tree of many programs (especially GNU ones). Thus you
can't fix it once and be done, you have to fix it in every single program that
uses it. The authors of this library think it is a good idea to let you run into
a compilation error instead of offering a portable fallback version of their
code, so they can show you their muscles when you come to ask for help as the
error message suggests to do. See
<http://www.mail-archive.com/bug-gnulib@gnu.org/msg27386.html> and
<http://www.mail-archive.com/search?q=musl&l=bug-gnulib%40gnu.org>.

To fix it, either update the in-tree gnulib (no idea how to do that), or use a
hack: each one of the gnulib function is triggered by a configure test, the
condition being either "libc doesn't have this function" or "this libc function
doesn't behave like GNUlib dictators want it to be". All of those configure
checks use a cache variable like "`gl_cv_func_isnanl_works=yes`" [bigger list].

So, you can prevent their code getting compiled in when you start configure with
`./configure gl_cv_func_isnanl_works=yes`. Alternatively, you can put all of
these symbols into a file called config.cache and run `./configure -C` (the `-C`
makes configure pick up the cache), so all these checks will be skipped.

To prevent additional breakage, [overwrite all .c files in the gnulib folder that try to replace libc functionality with an empty file][overwrite].
If that's still not enough to make gnulib happy, you may have to do additional preprocessor hacks so
their "`rpl_`" functions get again mapped to the real libc thing.

For example: `CFLAGS="-Dgnu_fnmatch=fnmatch -Drpl_getgroups=getgroups
-Drpl_nanosleep=nanosleep -Drpl_futimens=futimens" ./configure` ... [1].

[1]: https://github.com/sabotage-linux/sabotage/blob/master/pkg/coreutils#L16
[bigger list]: https://github.com/sabotage-linux/sabotage/blob/master/KEEP/config.cache#L1430
[gnulib]: https://gitlab.com/sortix/sortix/wikis/Gnulib
[overwrite]: https://github.com/sabotage-linux/sabotage/blob/master/KEEP/gnulibfix

# Q: None of these are questions!

Why would the Frequently Aired Quandaries page have questions?
