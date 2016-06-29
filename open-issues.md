# Open Issues

This wiki page is for tracking known, mostly longstanding issues that are
non-trivial to fix. Before adding an issue here, it should have been discussed
at least once on the mailing list or IRC channel. Simple bugs found can usually
be fixed right away.

[[_TOC_]]

# C locale conformance

Presently, musl's C locale is not quite conforming (to ISO C or POSIX), and the
situation will be worse in the future once the resolution to issue #663 is
applied to POSIX, disallowing multibyte characters in the C locale. The present
issues are:

- setlocale() returns "C.UTF-8" even if "C" was passed to it. (This is barely a
  functional issue; fixing it would just require saving a flag for which to
  return.)
- The character classes (wctype.h) contain characters not allowed to be present
  in the C locale by ISO C.

Fixing the second issue depends on fixing the first, but there are two possible
ways it could be fixed. One is to make the wctype.h functions stateful and
dependent on the current locale, so that they reject non-ASCII characters in the
pure "C" locale (which would only be active if you never call setlocale at all,
or explicitly pass "C" as an argument). The other possible fix would be to make
the encoding (UTF-8 vs abstract 8-bit) dependent on the locale. This would meet
the requirements of the POSIX interpretation for issue #663, and by making it so
that Unicode-range values of wchar_t never arise in the C locale, would
eliminate the need to make any changes to the current Unicode-aware wctype.h
functions.

This whole issue is very controversial. The argument on the Austin Group list
leading up to the resolution of issue #663 was heated itself, and the musl
community has differing opinions on whether we should ignore POSIX on this (and
keep the UTF-8 purity like Plan 9 has) or follow.

Any action on this item is dependent both upon policy-type discussions and upon
implementing a minimal locale framework that would allow for setting and keeping
global and thread-local locale state.

# Stateful encodings in iconv

Right now, musl's iconv descriptors are not identifiers for an allocated
resource, but just bitfields identifying the source and destination charset.
There has been some demand for stateful encodings, however:

- UTF-16 with BOM (yes, disgusting...)
    - ISO-2022 Japanese text (common on IRC still)

It's still an open question whether these are worth supporting.

# Publishing source code used to generate charset/Unicode data

There are a number of include files in the musl source tree full of numeric
tables used for processing character properties and conversions. These were
generated from published Unicode data using a mix of automated and manual
processes which should be published for the sake of completeness and so that
users can feel confident that they are not dependent on upstream for
maintenance.

# NIS/LDAP/other user databases

glibc supports alternate user databases via NSS (copied from Solaris);
traditional implementations have NIS support hard-coded in along with flat
files. musl does not support anything but flat files.

The direction planned in musl is not to add in the bloat of additional backends
or dynamically loading backends, but to offer a single protocol for
communicating with a daemon that would serve as the backend. Candidates are:

- nscd, the protocol used by the daemon that caches results of such lookups in
  glibc. The biggest advantage of this option is that you could use ANY backend
  supported by glibc by just installing the real glibc nscd. The protocol is
  mildly ugly but not bad.
- LDAP protocol with a daemon to translate LDAP to the desired backend.
- Trivial text-based protocol where query is sent as a string (username or uid)
  and the result comes back formatted exactly as it would be in a flat passwd
  file. This option is in some ways optimal because almost no additional code is
  needed.

# Security/hardening features

## Substitute for _FORTIFY_SOURCE

The current plan is to implement this in a libc-agnostic way as a second set of
headers on top of the libc headers, using "GNU C" features such as #include_next
and __builtin_object_size to provide a fully-inline (no use of special libc
functions) version of FORTIFY. [implementation](http://git.2f30.org/fortify)

## Building musl itself with stack-protector

This requires analysis of which library components are needed prior to
initialization of the stack-protector canary and TLS, and possibly special code
to use a temporary thread pointer while the dynamic linker is running, prior to
allocating the real TLS block, if omitting stack protector from all functions
used by the dynamic linker would be too great an omission.

## Further malloc hardening

It may be desirable to change malloc's bookkeeping so that the chunk footer
contains a pointer back to the header, rather than containing the size. This
would make it significantly harder for an attacker performing a buffer overflow
to avoid checks for the footer having been clobbered.

# Complex math

Currently most complex functions have dummy implementations. Correct
implementation is non-trivial (small ULP errors for both real and imaginary
parts without spurious floating-point exceptions and getting branch cuts right
with correctly signed zeros), some work has been done in FreeBSD libm (based on
the paper of Hull et al. about complex asin and acos) that might be usable in
musl.

# fnmatch logic

The fnmatch_internal function can be simplified (the check of the last '*'
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

Legacy functions operating on ucontext_t (getcontext, setcontext, makecontext,
swapcontext) are not implemented. They are no longer part of POSIX, but
cooperative multi-tasking applications use them. ucontext_t also appears as an
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

After some discussion, search domains were deemed a largely-harmful feature, so
support for them was not added. All other major features have now been
implemented, however.

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
synchronized with the close() function, meaning pending AIO operations could act
upon (and possibly corrupt) another file if their original fd was closed and the
file descriptor was reassigned. An analogous bug is also present in glibc's
implementation.

Details are available on this mailing list thread:
<http://www.openwall.com/lists/musl/2013/06/16/18>

