# Roadmap

Releases will continue to follow, roughly, a time-based release schedule, with
targets that may or may not be met for each individual release. The first couple
releases in the roadmap that follows are expected to follow their time estimates
and feature targets fairly closely. Past that, later releases are just rough
ideas or what might be feasible and worthy of prioritizing within the given time
constraints. The roadmap may change radically before we get there.

# musl 1.1.15

Estimated release: Early May

Primary targets:

- Merging in-progress MIPS n64 port
- Merging PowerPC soft-float support
- Dynamic linker correctness improvements
    - Separate loaded DSOs chain from global chain
    - Improved locking strategy for running ctors from dlopen
- Using stdio buffer provided to setvbuf

Secondary targets:

- Updating character data to current Unicode
- UB-correctness fixes including string functions and stdio
- Further dynamic linker performance improvements and clean-up
- Further build-system cleanup
- Adding GLOB_TILDE to glob implementation

# musl 1.1.16

Estimated release: June

Primary targets:

- Adding ARM Cortex-M (NOMMU) support (including building ARM as pure thumb2).
- Resolving GCC symbol-versioning incompatibility issue - see
  <http://www.openwall.com/lists/musl/2015/05/10/1>
- LC_COLLATE implementation
- IDN support in DNS resolver
- Message translation support for dynamic linker

Secondary targets:

- IEEE quad math correctness
- Complex math correctness Complex math correctness
- Remapping of glibc-ABI-incompatible symbols (regexec, etc.) by dynamic linker
- New getlogin[_r] with lookup via controlling tty
- Enhanced LSB/glibc ABI-compat, especially fortify \_\_*_chk symbols

# Milestone goals for musl 1.2.0

The following tentative goals for what would constitute "musl 1.2.0" have been
established. There is no projected release date for 1.2.0 at this time, but
there will likely be at least one additional release (beyond the above) in the
1.1.x series before 1.2.0.

- Cleanup & build system
    - Deduplication and asm-reduction of atomic operations
    - Deduplication of bits headers for archs
    - Support for out-of-tree builds
- Improved locale and multilingual support
    - LC_COLLATE support for collation orders other than simple codepoint order
    - IDN support in DNS resolver
    - Character data aligned with current Unicode at time of release
- Porting
    - Aarch64 (64-bit ARM) port
    - Promoting existing experimental ports up from experimental status
- Documentation
    - Bringing existing documentation into alignment with changes made since
      1.0.0
    - Documenting new and non-obsolescent extensions in detail
    - Adapting text from wiki and other sources on properties of the
      implementation relevant to programmers and end users
- Third-party projects
    - Non-glibc-based nscd-protocol backend for LDAP (and perhaps NIS)
    - Locale data and libc message translations
    - External header-file-only fortify library providing \_FORTIFY_SOURCE
      feature
    - Support for Windows targets via Midipix (<http://www.midipix.org>)

# Open longer-term goals

- Iconv overhaul with support for stateful encodings like ISO-2022-JP and BOMful
  UTF-16/32, and possibly support for converting to legacy CJK encodings (not
  just from them)
- Improving support for C++11 non-POD TLS objects (difficult due to GCC botching
  the ABI)
- Refactoring arch tree to reduce or eliminate bits header duplication
- Review wordexp implementation for conformance issues, fixing any found

# Postponed/tabled goals

- New semaphore implementation (delayed; design issues remain)
- Re-unifying x86_64 and x32 sigsetjmp.s

