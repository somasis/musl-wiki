# Design Concepts

# Unified libc/libpthread/ldso

Not only does musl lack separate broken-down libraries like libpthread, libm,
librt, etc. that glibc has; even the dynamic linker (in the elvish language,
"program interpreter") is unified with libc.so. This design helps achieve at
least four goals:

1. Reducing bloat and startup overhead: Each additional dynamic object,
   including the dynamic linker itself, costs at least 4k of unsharable memory
   and considerable additional startup time to map into memory and relocate.
2. Making atomic upgrades possible: A single rename() syscall can replace the
   entire runtime component of musl with a new version in a way that neither
   disrupts existing processes nor creates a race window during which programs
   could fail to start or could observe, and possibly malfunction from,
   mismatching library binaries.
3. Avoiding unnecessary ABI lock-in: By not breaking the implementation up into
   separate shared libraries, there is no need to define a stable ABI between
   components. All internal interfaces are purely internal, and freedom to
   change them is maintained.
4. Simplicity of the dynamic linker: By having libc already mapped by the
   kernel, and function calls already resolved by -Bsymbolic at link time, the
   dynamic linker has most of libc at its disposal as soon as the very first
   line of C code is reached. There is no need for duplication in the dynamic
   linker of standard libc functions it needs to use, nor any need to tiptoe
   around until relocations are fully processed.

In the early design stages of musl, it was unclear whether musl would provide
its own dynamic linker or use an existing one. The initial motivation for
providing its own was to eliminate the bloat costs of dynamic linking, but
during development, the other, more compelling reasons became apparent.

A classic Linux system (glibc or even back to libc5) gives the illusion that the
dynamic linker, libc, and threads implementation are separate components, and
that you could swap out any of these for an alternate implementation while
keeping the others. In a sense this was true at some point, before any of them
really worked properly. But now they are all extremely interdependent, and
burdened by their dependencies on one another's private interfaces. Some
examples:

- Interaction between libc and ldso for handling of init/fini, atexit type
  registrations, library unloading, ...
- Interaction between pthreads and ldso for TLS storage for dynamic libraries.
- Interaction between libc and pthreads (and even the compiler) for
  non-thread-related data stored in thread control block (vdso syscall pointer,
  stack protector canary, ...).

The key reason musl needed its own dynamic linker was that glibc's dynamic
linker was too tied in to the workings of glibc, and particularly into designs
(for library loading and TLS) that could not be made robust without completely
replacing them. With the decision to include a new dynamic linker made, but
without a preexisting API design to link it with libc and threads, the most
practical choice was to have it all be part of one library, and avoid the
difficult (and useless) problem of creating a long-term API/ABI between
components. This also greatly simplified the dynamic linker design and
implementation.

# Thread cancellation

Adapted from <http://www.openwall.com/lists/musl/2011/04/18/1>

The current thread cancellation design in musl is the second in a series of
designs to rememdy two critical flaws in the classic way cancellation is
implemented by glibc and other libraries:

1. Cancellation can act after the syscall has returned successfully from
   kernelspace, but before userspace saves the return value. This results in a
   resource leak if the syscall allocated a resource, and there is no way to
   patch over it with cancellation handlers.
2. If a signal is handled while the thread is blocked at a cancellable syscall,
   the entire signal handler runs with asynchronous cancellation enabled. This
   could be extremely dangerous, since the signal handler may call functions
   which are async-signal-safe but not async-cancel-safe.
3. At the time this system was designed, there were mixed opinions on whether
   these flaws are violations of the POSIX requirements on cancellation. Now,
   based on the resolution to issue 614 on the Austin Group tracker
   (<http://austingroupbugs.net/view.php?id=614>), it's clear that POSIX does have
   very specific requirements for the side effects of functions when they are
   cancelled. Either way the above flaws make it virtually impossible to use
   cancellation for the intended purpose. Both flaws stem from a
   cancellation-point idiom of:

        1. Enable asynchronous cancellation.
        2. Perform the operation (usually a syscall).
        3. Disable asynchronous cancellation (actually restore the old state).

The first idea to remedy the situation appeared in musl 0.7.5, but turned out to
have its own set of flaws. The new approach, which works like this:

A specialized version of the syscall wrapper assembly code is used for
cancellation points. Originally, it recorded its stack address and a pointer to
the syscall instruction in thread-local storage, but this approach turned out to
have some flaws too, and eventually it was simplified to just use
externally-visible labels in the assembly code. The cancellation signal handler
can then compare the instruction pointers of the interrupted context to
determine at which point the cancellation request came:

- in the code leading up to, or while blocked at, the syscall,
- after completion of the syscall, OR
- while executing a signal handler which interrupted the syscall.

In the first case, cancellation is immediately acted upon. In either of the
second two cases, the cancellation signal handler re-raises the cancellation
signal, but leaves the signal blocked when it returns. The cancel signal can
then only be unblocked in the third case, when a previously-executing signal
handler returns and restores its saved signal mask. This will immediately
trigger the cancellation signal again, and it can inspect the context again. If
there are multiple layers of signal handlers between the original cancellation
point and the cancellation signal handler, each one will be peeled off in this
way as they return, and the cancellation request will propagate all the way
back.

Surprisingly, this entire cancellation system has very few machine dependencies,
beyond the need for machine-specific syscall code which was already a
requirement. Everything else is written in plain POSIX C, and makes only the
following assumptions:

- The saved context received by signal handlers contains the saved value of
  the current instruction address from the interrupted code (the offsets for
  these are defined in an arch-specific file).
- Restartable syscalls work by the kernel adjusting the saved instruction
  pointer to point back to the syscall instruction rather than the following
  instruction.

For comparison, an earlier attempt as this design depended on an arch-specific
macro to read code from the saved instruction pointer and inspect for the
syscall opcode. This turned out to be the wrong approach for several reasons.

One limitation of this whole design, on plain x86 (not x86_64), is that it is
incompatible with the "sysenter" method of making syscalls. Fortunately,
relatively few syscalls are cancellable, and there is no reason the
non-cancellable majority of syscalls could not use the "sysenter" syscall
method.

Aside from the correctness benefits, the new cancellation implementation has
been factored to avoid pulling cancellation-related code into static-linked
programs that don't use cancellation, even if they use other pthread features.
This should allow for even smaller threaded programs.

# Thread-local storage

The TLS implementation in musl is based on the principle of reserving all
storage at a time when failure to obtain storage is still reportable. This is in
contrast to other implementations such as glibc which are forced to abort when
lazy allocation fails.

There are only two operations which can increase a process's TLS needs:
pthread_create and dlopen. During dlopen, a lock is held which prevents the
creation of new threads, so dlopen can use the current thread count to allocate
sufficient storage for all currently-running threads at the time the library is
loaded; if storage cannot be obtained dlopen returns failure. Before releasing
the lock that prevents thread creation, dlopen updates the record of how much
TLS storage new threads will need and makes it available future calls to
pthread_create, which pre-allocate storage for TLS in all libraries that were
loaded at the time of the call.

Before a new thread begins execution, TLS pointers are already setup, and the
TLS images have all been copied, for TLS belonging to libraries that were loaded
before the thread was created. If a thread attempts to access TLS in a library
that was loaded after the thread started, the \_\_tls_get_addr function searches
the list of loaded libraries to find the pre-allocated storage that was obtained
when the library was loaded, and uses an atomic-fetch-and-add operation to
adjust the index into this storage. This makes access to the pre-allocated
storage both thread-safe (since other threads might need to acquire part of it)
and async-signal-safe (important for supporting the case where the first access
to a library's TLS takes place in a signal handler or after forking).

One consequence of this design is that there is memory which is never freed.
However, the point at which this memory is allocated is in dlopen, an interface
which inherently allocates an unfreeable (in musl, for various good reasons)
resource: a shared library. If for some reason there exists an extreme,
unusually large number of threads at the moment dlopen is called, however, the
permanent allocations could be costly. It may be possible to arrange for some or
all of this memory to be freeable upon thread exit, by carving up the large
allocation into individual pieces returnable to the malloc subsystem via free.
Such enhancements will be considered at a later time if there is demand.

# Time conversion subsystem

Adapted from <http://www.openwall.com/lists/musl/2013/07/16/16>

Internally, all POSIX times (seconds since epoch) are passed around as long
long. This ensures that values derived from struct tm, timezone rules, etc. can
never overflow, and allows overflow checking to be deferred until it's time to
convert the value back into time_t. Without this design, handling the "partial
years" at the edge of time_t overflow range is very difficult, as is handling
the denormalized struct tm forms mktime is required to support and normalize
(for instance, overflowing the year range by using a very large month number).

Instead of converting back and forth to broken-down struct tm for applying
timezone rules, the new code simply converts the combination of year and TZ rule
string to a POSIX time within the given year at which the transition occurs.
This value has type long long so that it cannot overflow even at the boundary
years. Determining whether DST is in effect at a given time is simply a range
comparison, just like the comparison used for processing zoneinfo-format
timezone rules.

For years within the currently-reasonable range/32-bit time_t, the hot path for
converting a year to seconds since the epoch involves no division. We can get
away with >>2 and &3 since in the range [1901,2099] the leap year rule is simply
that multiple-of-4 years are leap years. I would like it be able to have the
compiler throw away the larger, slower, general-case code on 32-bit-time_t
targets, but unfortunately the need to use long long internally to avoid
difficult corner cases is precluding that.

Any representable struct tm will successfully convert to time_t if and only if
it represents a value of seconds-since-the-epoch that fits in time_t. Any
representable time_t will successfully convert to struct tm if and only if it
represents a (normalized) date and time repr esentable in struct tm. The
relevant functions will avoid setting errno except on error so that a caller can
distinguish between a time_t value of -1 as a valid result and as an error.

