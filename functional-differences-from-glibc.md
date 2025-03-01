# Functional differences from glibc

# The stdio implementation

## printf behavior

glibc supports some alternate incorrect format specifiers, like `%Ld` as an alias
for `%lld`. musl does not support these, and returns an error upon encountering
them.

musl does not support glibc's custom format specifier registration system.

musl's floating point conversions honor rounding mode. glibc's do not.

## Behavior on end of file

ISO C and POSIX require the end-of-file status for a FILE to be sticky, i.e. for
it to preclude further reads once it's set, unless it's explicitly cleared. musl
has always honored this requirement. glibc versions prior to 2.28 ignored it and
always returned new input, if available, even after the EOF flag is set.

## Read and write patterns

musl uses `readv` and `writev` for implementing stdio:

- When a read cannot be satisfied from the buffer, a single `readv` call
  transfers the remaining request to the caller's buffer and fills the stdio
  buffer.
- When a write cannot fit in the remaining space in the buffer, a single write
  call transfers the write buffer and the data to be written from the caller's
  buffer to the underlying file descriptor.

Normally this just yields good performance independent of heuristics on when to
buffer and when to transfer. However, it does also impact how Linux interprets
some writes to files in `/proc`.

# Signal mask and setjmp/longjmp

By default, glibc provides the legacy BSD behavior for `setjmp`/`longjmp`, saving
and restoring the signal mask as part of the `jmp_buf`. musl never includes signal
masks unless you use `sigsetjmp`/`siglongjmp` and specifically request that the
signal mask be saved/restored. Per POSIX, correct applications cannot rely on
setjmp to save the signal mask, so musl's behavior gives much better performance
for applications which do not care and which are using the interfaces correctly.

# Regular expressions

musl's regex implementation is based on TRE, with significant modifications.
Some popular extensions are supported, but not all; in particular, up until
version 1.1.13 it lacked some of the common extensions to POSIX BRE that add
ERE-like capabilities to BRE.

The GNU regex implementation also has an alternate API which can be used instead
of the POSIX API. This alternate API is not supported by musl at all.

Finally, glibc's regex uses a 32-bit `regoff_t` even on 64-bit archs. This is
non-conforming to POSIX and precludes giving correct output for strings larger
than 2GB. musl uses a correct type, but this renders the ABI of the regex
functions incompatible on 64-bit archs. The ABI is compatible on 32-bit.

# Re-entrancy of exit

Calling exit more than once invokes undefined behavior. musl does not support
recursive calls to exit (via atexit functions/destructors) or simultaneous calls
to exit (from multiple threads). The error is not diagnosed and may give
unexpected results, or may happen to do what the programmer intended. musl used
to deadlock when exit was called recursively and gracefully handled exit from
multiple threads, but the code that caused this behavior was removed in 1.1.2.
glibc does not deadlock under recursive exit, but it's unclear whether such
usage just "happens to work" or whether it's supported.

# Dynamic linker

## Lazy bindings

glibc's dynamic linker supports lazy binding: deferring resolution of symbol
references to the first time the function is called. In theory this reduces
startup latency if a large number of references are never used; in reality, it
sometimes increases it by delocalizing the accesses. In any case, musl does not
support lazy binding. This is both for robustness reasons (reporting failure of
lazy binding is impossible) and because it greatly reduces the amount of
fragile, arch-dependent code needed in the dynamic linker. Such code has been a
perpetual source of bugs in the glibc implementation.

Until version 1.1.17, this difference was visible to applications which
call dlopen on multiple libraries without proper dependency information, such
that, once all libraries are loaded, they all satisfy each other's dependencies,
but individually, the first library has unresolved symbols. This is erroneous
usage and could also break on archs where full lazy binding is not possible or
practical. Newer versions of musl implement "deferred binding" in place of lazy
binding, whereby binding is deferred until a subsequent dlopen call that
introduces new symbols, rather than at the point of the function call.

## Unloading libraries

musl's dynamic loader loads libraries permanently for the lifetime of the
process, until it exits or calls exec. `dlclose` is a no-op. This is very
different from glibc's approach of reference counting libraries and unloading
them when the count reaches zero. The differences in observable behavior to
applications:

- Destructors will run on `dlclose` (as long as there are no remaining references)
  under glibc, and subsequent opens of the same library will run their
  constructors again. Under musl, constructors only run the first time a library
  is run, and destructors only run on exit.
- Under glibc, the contents of all static storage in a library will be reset to
  its original state if the library is unloaded and reloaded. Under musl, it
  will never be reset.
- Address space from a library remains tied up even after `dlclose` on musl, so
  opening and closing an infinite family of libraries will eventually consume
  the entire address space and other resources. However, as long as there's only
  a finite set of libraries being opened and closed, address space usage will be
  bounded. Under glibc, address space from closed libraries is free to be used
  again.

Either behavior conforms to POSIX, but only the musl behavior can satisfy the
robustness conditions musl aims to provide. In particular:

- Under glibc's approach, libraries not designed with `dlclose` in mind (which
  may not be the libraries directly loaded with `dlopen`, but rather their
  dependencies) may leave around references to themselves in such a way that
  removing them from the address space results in a crash (or worse) later on.
  This cannot happen under musl.
- Managing storage for thread-local objects is much more difficult if dlclose
  unloads libraries. If space is to be reserved in advance (needed to guarantee
  no late/unrecoverable failures), supporting unloading in `dlclose` seems to
  necessitate leaking TLS memory, which largely defeats the purpose of doing the
  unloading in the first place.

## Thread-safety of `dlerror`

POSIX 2008+TC1 allows `dlerror` to be thread-safe (with a thread-local error
buffer) or non-thread-safe (with a global buffer). Prior versions required it to
use a global buffer.

glibc has provided a thread-local `dlerror` result for a long time. Versions of
musl up through 1.1.8 honored an old POSIX requirement and had global `dlerror`
state. Starting with 1.1.9, musl's `dlerror` state is thread-local and now matches
the glibc behavior.

## Symbol versioning

glibc allows the usage of versioned symbols through version tables in
gnu-specific elf sections. the musl dynlinker only supports the subset of symbol
versioning that allows to pick the default symbol version, instead of the oldest
version, which comes first in the regular symbol tables.

# Threads

## Thread stack size

The default stack size for new threads on glibc is determined based on the
resource limit governing the main thread's stack (`RLIMIT_STACK`). It generally
ends up being 2-10 MB.

musl provides a default thread stack size of 128k (80k prior to 1.1.21).
This does not include the guard page,
nor does it include the space used for TLS unless total TLS size is very small.
So the actual map size may appear closer to 1400k, with around 128k usable by
the application. This size was determined empirically with the goals of not
gratuitously breaking applications but also not causing large amounts of memory
and virtual address space to be committed in programs with large numbers of
threads. Programs needing larger stacks, or which explicitly want a smaller
stack, should make this explicit with `pthread_attr_setstacksize`. For largely
unrestrained use of the standard library, a minimum of 12k is recommended, but
stack sizes down to 2k are allowed.

Since 1.1.21, musl supports increasing the default thread stack size via the
`PT_GNU_STACK` program header, which can be set at link time via
`-Wl,-z,stack-size=N`.

## Thread cancellation

musl provides strong guarantees of the POSIX-specified side effects being
observed when a function which is a cancellation point is cancelled: either the
side effects are as if the function returned failure with a status of EINTR, or
the function returns success and does not act on cancellation. glibc has no such
guarantees.

Cancellation cleanup handling in musl has no relationship to C++ exceptions and
unwinding. Any destructors or exception handlers present when acting on
cancellation will not be run. Per the standards, cancellation under such
conditions yields undefined behavior, but glibc implements cancellation as an
exception and thus both cancellation cleanup handlers and exception
handlers/dtors get run.

# Character sets and locale

## The C/POSIX locale

glibc presently has a pseudo-ASCII, pseudo-8-bit C locale: it only defines
characters 0 through 127, and the multibyte interfaces treat high bytes as
EILSEQ, but on the other hand regex, fnmatch, glob, etc. accept high bytes.

Up through version 1.1.10, musl provided a purely UTF-8 C locale. Despite being
unusual, this had precedent (Plan 9) and is explicitly permitted by the ISO C
standard (it's documented as an option in the MSE1 Rationale document). However,
many scripts expect to be able to process data which is not valid UTF-8 using
the standard utilities by setting `LC_CTYPE=C`, and as of Spring 2013, the Austin
Group (responsible for maintaining POSIX) resolved to require in future versions
of the standard that the C locale be "8 bit clear", i.e. treat each possible
byte as an abstract character, to facilitate processing data in unknown or mixed
encodings and other dubious uses. This rendered both glibc's and musl's
behaviors non-conforming.

Starting with version 1.1.11, musl provides a special C locale where bytes
0x80-0xff are treated as abstract single-byte-character units with no actual
character identity (they're mapped into `wchar_t` values that occupy the Unicode
surrogates range). All other locales are still processed as multibyte UTF-8, and
the intent is that the plain C locale's character set be thought of as "UTF-8,
but processed byte-by-byte and without validation".

## Default locale

In the absence of the `LANG` and `LC_*` environment variables, POSIX leaves the
default locale (used when `""` is passed to `setlocale`) implementation-defined.
Under glibc versions at least up through 2.26, this default is `"C"`. musl on
the other hand always uses `"C.UTF-8"` as the default. There has been discussion
on the glibc side of possibly adopting the musl behavior here once the `"C.UTF-8"`
locale is an established feature of glibc.

## UTF-8 definition

musl uses the Unicode and modern ISO 10646 definition of UTF-8, which is a
one-to-one mapping between the Unicode Scalar Values 0-0xd7ff,0xe000-0x10ffff
and valid 1-4 byte sequences. In particular, surrogates are rejected, "over-long
sequences" are rejected, and pseudo-UTF-8 sequences of 5 or 6 bytes (which would
correspond to non-Unicode-scalar-value numbers beyond 0x10ffff) are rejected.
glibc on the other hand accepts 5 and 6 byte sequences.

Aside from being a matter of standards conformance, accepting sequences only up
to 4 bytes allows for the possibility of generating UTF-8 output in a buffer
intended for `wchar_t`, then converting it in-place, which is necessary for some
interfaces that cannot rely on being able to allocate working space.

## iconv

The iconv implementation musl is very small and oriented towards being
unobtrusive to static link. Its character set/encoding coverage is very strong
for its size, but not comprehensive like glibc's. In particular:

- Many legacy double-byte and multi-byte East Asian encodings are supported
  only as the source charset, not the destination charset. JIS-based ones
  are supported as the destination as of version 1.1.19.
- Conversion to ISO-2022-JP is stateless and produces shifts in/out of
  nondefault states around each character.
- Transliterations (//TRANSLIT suffix) are not supported.
- Converting to legacy 8-bit charsets is significantly slower than converting
  from them.
- Prior to version 1.1.19, conversions from plain UTF-16 or UTF-32
  without an explicit endianness assumed big endian and did not honor
  BOM. Now they honor BOM, but BOM is never produced in output.
- Misleading, deprecated charset aliases like UNICODE as an alias for UCS-2 are
  not supported. The IANA preferred MIME charset names should be used instead.
- Contrary to POSIX, glibc iconv generates EILSEQ when a character is not
  representable in the destination charset. musl, in accordance with POSIX,
  performs an implementation-defined conversion and returns the number of such
  inexact conversions performed. At present, it replaces the character with an
  asterisk, but something akin to glibc's //TRANSLIT mode may be substituted in
  the future. Code written assuming the glibc semantics (error when no exact
  conversion is possible) may need to be tuned to work well on musl and other
  conforming iconv implementations.

# Floating-point and mathematical library

## Floating-point support

musl implements the library requirements for C99 Annex F. Unlike glibc, musl
does not try to support non-conforming floating-point formats and arithmetics
(eg. the powerpc abi with software long double using two doubles, the IBM long
double format).

## Floating-point exceptions

glibc supports exception unmasking using fesetenv with non-standard fenv
setting. musl does not support exception unmasking and library functions assume
exceptions are always masked (floating-point arithmetics never trap).

IEEE 754 specifies five exception **signals** and five exception **status
flags** as well (inexact, invalid, divbyzero, underflow, overflow). The signals
are all masked in the default environment so in case of an exceptional condition
the system does not trap but delivers a default result and raises the
appropriate status flag. (Note: exact underflow is a special case that signals
the underflow exception but does not raise the underflow status flag). The C
standard does not provide any way to unmask the exception signals (but the
specification of feraiseexcept and fesetexceptflag takes unmasked exception
signals into account). Thus a conformant implementation can behave as if
floating-point computations never trap, the observable behaviour is conforming,
unless the application circumvents the libc (eg. by using assembly) and unmasks
the exception signals (or invokes other unspecified fenv operations, eg. changes
the x87 FPU precision setting on i386) in which case the behaviour of library
functions is undefined.

## `math_errhandling`

glibc supports non-zero `math_errhandling` & `MATH_ERRNO`, ie. exceptional
conditions of the mathematical library are reported in errno. musl only supports
`MATH_ERREXCEPT`.

At least one of `MATH_ERRNO` and `MATH_ERREXCEPT` must be supported and Annex F
requires `MATH_ERREXCEPT` support. Old platforms and platforms without FPU may not
provide the necessary IEEE 754 exception semantics for `MATH_ERREXCEPT`. On such
platforms an implementation can only fall back to the classic errno based error
reporting that was already present in C89. (Note: the errno based method
provides less information, only EDOM and ERANGE is reported and the semantics is
less precise).

On software FPU platforms without hardware register for floating-point status
flags the software emulation library (provided by the compiler, eg. libgcc) can
emulate the status flags with thread storage duration. Currently the status
flags are not emulated, so musl is non-conforming on such platforms (neither
errno nor fp exceptions are supported).

# Name Resolver/DNS

Traditional resolvers, including glibc's, make use of multiple nameserver lines
in `resolv.conf` by trying each one in sequence and falling to the next after one
times out. musl's resolver queries them all in parallel and accepts whichever
response arrives first. This can increase network load (this is mitigated by
only supporting up to three nameservers, and can be mitigated further at the
configuration level by only configuring one nameserver) but drastically improves
performance and reliability of DNS lookups, especially if diverse nameservers
are used. An ideal configuration is:

- Caching nameserver on localhost (near-zero latency for locally cached results,
  but typically smallest cache size, and slowest for queries not serviceable
  from cache)
- ISP nameserver (very low latency for cached results, typically moderate cache
  size, and moderate performance for queries not serviceable from cache)
- 8.8.8.8 (somewhat higher latency but tends to have the whole DNS tree cached)

Try to make sure that your nameservers agree on the answers they give, as it's
[not guaranteed](https://github.com/louislam/uptime-kuma/issues/4798) that the
first response will be from a local nameserver.

If musl's resolver is requested to translate a hostname to IPv4 and IPv6, both
requests will use the same socket, same as glibc. glibc could be configured to
send those requests sequentially, with `single-request` and
`single-request-reopen` options, but musl cannot.

musl's resolver previously did not support the `domain` and `search` keywords in
resolv.conf. This feature was added in version 1.1.13, but its behavior differs
slightly from glibc's: queries with fewer dots than the `ndots` configuration
variable are processed with search first then tried literally (just like glibc),
but those with at least as many dots as ndots are only tried in the global
namespace (never falling back to search, which glibc would do if the name is not
found in the global DNS namespace). This difference comes from a consistency
requirement not to return different results subject to transient failures or to
global DNS namespace changes outside of one's control (addition of new TLDs).
`search` lines in musl are ignored if they exceed 256 chars. Newer versions
of glibc do not have this limitation. Generally it's recommended to avoid
`search` use as it results in abysmal performance.

glibc supports IDN (non-ASCII name lookups via DNS) but requires the use of
custom non-standard flags to `getaddrinfo` and `getnameinfo` to convert such names
to/from the internal representation used in the DNS system (Punycode). musl does
not yet support IDN conversions at all (but programs that know about
IDN/Punycode and do the conversions themselves can of course lookup such names),
but when support is added, it will always be enabled rather than requiring
explicit options from the application.

musl's resolver did not support the use of DNS over TCP until version 1.2.4. This
difference prevented the use of larger packets produced by protocols such as
DNSSEC and DKIM.

musl also does not implement the following glibc bugs:

- When the `hints` parameter for `getaddrinfo` is unset, glibc sets the
  `ai_protocol` field, which is
  [non-complaint](https://github.com/libuv/libuv/issues/2225#issuecomment-765808228).
- When `getaddrinfo` is called with `AF_UNSPEC`, glibc returns a result
  even if one of the address families returns `ServFail`.  This is a bug
  (glibc #27929) and may undermine DNSSEC.

# Miscellaneous functions with GNU quirks

- GNU `getopt` permutes argv to pull options to the front, ahead of non-option
  arguments. musl and the POSIX standard `getopt` stop processing options at the
  first non-option argument with no permutation.
- glibc provides two versions of `basename`. The one declared in stdlib.h has
  alternate semantics and signature that conflict with the standard. musl only
  provides the standard one.
- glibc provides a thread-safe `system`. Thread safety for `system` is not 
  required by POSIX and musl's version is not thread-safe.

