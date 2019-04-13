# Guidelines for Distributions

Obviously we cannot control how distributors use musl; it's free software, and
anyone is free to make local changes/forks that don't follow the intended usage.
However, the following are guidelines written from a standpoint of helping
systems integrators using musl to avoid some (possibly non-obvious) pitfalls
that would preclude interoperability of binaries from/with other musl-based
systems.

# Standard Pathnames

The musl developers have attempted to avoid gratuitous dependence on fixed
pathnames and have used existing, well-established ones when possible rather
than inventing new ones. For compatibility of dynamic-linked musl-based binaries
across different systems, the most important is the location of the dynamic
linker. It should always be at `/lib/ld-musl-$ARCH.so.1`, where `$ARCH` is the full
arch/sub-arch name produced by musl's configure script for the target
architecture/ABI combination. It does not matter whether it's an actual file or
a symbolic link to a file in another location, as long as it's available at boot
time (or as soon as you need dynamic-linked binaries to work). This pathname
exactly (and not other variants based on your distribution's symbolic link
layout, etc.) should appear in the PT_INTERP header of dynamic-linked programs.

For other standard pathnames, like `/etc/resolv.conf`, `/etc/passwd`, etc. it's
non-invasive (but not officially supported) to change them in libc.so; dynamic
linked programs will automatically use whatever libc.so uses. For static
linking, however, it's problematic to do so since the binaries will be tied down
to your particular FS layout and not compatible with other systems. If possible,
it's best to just stick with all the standard pathnames.

# Adding Functions

If musl is missing functions which are present in another libc and which are
needed by programs you want to package for your distribution, there are several
options for how to proceed:

- The safest solution is always putting the new functions in a separate
  (preferably static) library file and linking them into the programs that need
  them. This will not affect backwards compatibility, forwards compatibility,
  compatibility with foreign musl-linked binaries (from other musl-based
  systems), or compatibility with foreign musl ld.so (using your distribution's
  binaries on other musl-based systems).
- For functions where there is an upstream commitment to adding it in a future
  version, patching it into your libc might be an option. Programs built
  against it would then have a requirement which could be satisfied either by
  your custom libc or a future "stock" musl. Care should be taken not to
  introduce subtle incompatibilities or interface-contract bugs which your
  programs might come to depend on, however.

# Adding or Changing Features

When a feature does not affect the public API of an interface (examples:
alternate passwd database backends, cpu-model-specific memcpy optimizations,
etc.) there is no harm to compatibility in adding it locally. Some cases are
more borderline (examples: adding iconv charsets, adding non-standard regex
extensions, etc.) in that applications could depend on them and fail to work
with a "stock" musl libc that does not provide them, and it's probably best to
attempt to coordinate such additions with upstream (at least to make sure that
your local changes don't conflict with future plans upstream).

When a feature does affect public API (example: additional `GLOB_*` flags) it's
effectively much closer to adding a function (see above).

# Multilib/multi-arch

musl does not support sharing an include directory between archs (or
32-/64-bit "versions of the same target" in GCC multilib framing), and
thus is not compatible with GCC-style multilib. It is recommended that
distributions build GCC with multilib disabled, and use library
directories named `lib`, not `lib64` or `lib32`. Most importantly (see
above) distributions should not change the dynamic linker location to
`/lib64` or anything else, since this breaks ABI.

musl does support full multiarch with separate include and lib paths
for each separate arch/ABI in the same filesystem, similar but not
exactly the same as what Debian does. (Debian shares top-level include
just not `sys` and `bits`; for musl this may unofficially work but
it's not officially supported and there's no reason to believe it's
compatible with 3rd-party libs that may install arch-dependent headers
generated at build time into that dir.)
