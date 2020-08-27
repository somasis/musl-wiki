# Open Issues

This wiki page is for tracking known, mostly longstanding issues that are
non-trivial to fix. Before adding an issue here, it should have been discussed
at least once on the mailing list or IRC channel. Simple bugs found can usually
be fixed right away.

# Sanitizer compatibility

The upstream GCC and LLVM sanitizer library-side implementations rely
heavily on access to libc internals and are not compatible with musl.
UBSan is usable in trap-only mode but the other sanitizers are mostly
unusable. Support for these tools is desired, but exposing internals
as public interfaces is not, and sanitizer support will probably
eventually be implemented as providing the necessary library functions
in musl itself rather than use of the compiler-provided libraries.

# Complex math

Currently most complex functions have dummy implementations. Correct
implementation is non-trivial (small ULP errors for both real and imaginary
parts without spurious floating-point exceptions and getting branch cuts right
with correctly signed zeros), some work has been done in FreeBSD libm (based on
the paper of Hull et al. about complex asin and acos) that might be usable in
musl.

# fnmatch logic

The `fnmatch_internal` function can be simplified (the check of the last `'*'`
pattern component can be removed) and it has corner-cases where EILSEQ might not
be handled correctly.

# sbrk emulation

sbrk cannot be used safely, but some applications rely on it anyway. A possible
solution is to emulate it with mmap.

# Legacy non-libc headers

Some structs in procfs.h and user.h are only used by gdb, but for historical
reasons glibc provided them. Needs investigation who uses these and possibly
provide a legacy header set separate from the libc headers.

# ucontext.h

Legacy functions operating on `ucontext_t` (getcontext, setcontext, makecontext,
swapcontext) are not implemented. They are no longer part of POSIX, but
cooperative multi-tasking applications use them. `ucontext_t` also appears as an
argument to sigaction handlers which cannot be used portably.

# Previously posted issues which were resolved

## Missing libresolv functions

The following issue was fixed in musl 1.1.2:
>The resolver (DNS) framework in musl is a legacy-free implementation from
>scratch, but it was designed without any awareness of the legacy libresolv
>interfaces on which traditional gethostbyname/getaddrinfo implementations were
>built, and thus we have run into several instances of applications needing
>libresolv-style functions that did not exist in musl. Most of them had been
>added, haphazardly, in ways that either result in code duplication or lack the
>desired simplicity and efficiency we could have if the resolver itself were
>integrated with these functions.

## Lack of features in resolver

The following issue was fixed across musl 1.1.2 and subsequent work on 1.1.3:

>The traditional resolver supports searching multiple domains for a hostname,
>returning a mix of IPv4 and IPv6 addresses from /etc/hosts, etc. While
>low-priority, it would be nice to be able to duplicate some of these features.
>Addressing this issue is mainly a matter of refactoring getaddrinfo and the DNS
>code on which it depends; it should probably be done at the same time as the
>libresolv functions.

After some discussion, search domains were deemed a largely-harmful
feature, so support for them was not initially added. Later, version
1.1.13 introduced search domains, but with stronger constraints than
traditional implementations designed so that transient, potentially
attacked-controlled failures cannot alter the results of a query. This
establishes compatibility with systems using search domains in many
but not all ways; the use cases that do not work were always unsafe
and should be changed.

## C++ ABI compatibility

As of musl 0.9.12, the C++ ABI is stabilized and compatible with glibc's C++
ABI. This is sufficient for loading a glibc-built libstdc++ under musl, and for
running C++ programs that were linked to glibc as long as they otherwise meet
the requirements for working with musl. However, it's still insufficient for
musl-gcc to be able to build C++ programs using the existing toolchain on a
glibc-based host.

Getting musl-gcc working with C++ is still an open issue, but it's not an issue
in musl so much as an issue of figuring out an approach to getting C++ headers
that are usable with musl, without first needing to build a new libstdc++, and
installing them, setting up the right paths, etc.

## Removing lazy initialization of the thread pointer

The following was addressed in musl 1.1.0, with follow-up to improve
compatibility with pre-2.6 kernels between 1.1.2 and 1.1.3:

>This will add a one-syscall overhead at startup even in programs which don't
>need it, but will allow large optimizations in many places, including
>optimizations which reduce code size and bloat and eliminate complexity.
>However, making such a change is contingent on making sure it does not preclude
>support for ancient kernels where the thread pointer setup syscalls are
>missing.

## brk failures

The following issue was fixed in musl 1.1.0:

>Currently malloc uses brk for small allocations. If brk fails then malloc fails
>even if there is still mmapable space. A common cause of brk failure is a kernel
>bug in ASLR for PIE binaries which allows very small heaps, but brk can fail
>whenever an mmaped region is in the way. The malloc design needs some changes to
>allow fallback to mmap.
>
>Glibc does do the fallback, but that results significantly slower allocation
>than with brk adding a huge penalty for using PIE (until the kernel bug is
>fixed).

## C11 Conformance

Full C11 coverage was added in musl 1.1.5; the main addition was the C11 threads
API. The optional (and controversial) Annex K is not included. The current plan
is to hold off on taking any action towards supporting Annex K unless/until
other implementations adopt it and applications are using it.

## Private futexes

Private futex support was also added in musl 1.1.5. Fallback for old kernels is
not cached to avoid imposing high costs (e.g. global accesses via PIC and/or TLS
accesses) on modern kernels.

## POSIX AIO

Up through musl 1.1.6, the POSIX AIO implementation had significant conformance
and quality of implementation issues. The most serious was that AIO was not
synchronized with the `close()` function, meaning pending AIO operations could act
upon (and possibly corrupt) another file if their original fd was closed and the
file descriptor was reassigned. An analogous bug is also present in glibc's
implementation.

Details are available on this mailing list thread:
<http://www.openwall.com/lists/musl/2013/06/16/18>

## C locale conformance

Starting with version 1.1.11, musl's C locale conforms to the future POSIX requirement
(resolution to Austin Group issue #663) that the C locale's character encoding be
single-byte. Previously, the default locale was called "C.UTF-8", was fully multibyte,
and the results of some of the `wctype.h` functions in this locale were not conforming
to the C language's requirements on the C locale.

## Stateful encodings in iconv

Up through 1.1.18, musl's `iconv` implementation did not support stateful
encodings; `iconv_t` descriptors were pure values encoding the source and
destination charsets. Beginning with 1.1.19, stateful encodings will also
be supported, most notably ISO-2022-JP.

## Source code used to generate charset/Unicode data

This code was previously unpublished, making it difficult for anyone but the maintainer
to update or customize the tables. It is now available on GitHub at:

<https://github.com/richfelker/musl-chartable-tools>

## NIS/LDAP/other user databases

Up through 1.1.6, only the `passwd`/`group` files were supported for user and
group database functionality. musl 1.1.7 added support for alternative backends
via the NSCD protocol. There is an implementation of the server side of this
protocol that can use glibc-style NSS modules for backends at:

<https://github.com/pikhq/musl-nscd>

## Substitute for `_FORTIFY_SOURCE`

This has been implemented in a libc-agnostic way as a second set of
headers on top of the libc headers, using "GNU C" features such as `#include_next`
and `__builtin_object_size` to provide a fully-inline (no use of special libc
functions) version of FORTIFY. See:

<https://git.2f30.org/fortify-headers>

## Building musl itself with stack-protector

musl 1.1.9 introduced the ability to build libc itself with stack protector
options. Previously, early-init-stage considerations precluded this.

## Further malloc hardening

The adoption of mallocng in musl 1.2.1 mostly resolved the existing
malloc-hardening wishlist. Still, further gains may be possible in the
future including of MTE and other hardware-assisted protection.
