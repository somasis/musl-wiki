# Roadmap

We aim to follow roughly a time-based release schedule. The roadmap describes likely
focus and goals for current and upcoming release cycles, but these may change in the
interest of keeping releases moving or meeting areas of user and developer interest.


# musl 1.1.19

Estimated release: Mid December

Goals & Focus:

- `iconv` improvements:
    - Stateful encoding framework
    - ISO-2022-JP support
    - Reverse mappings (Unicode-to-legacy) for JIS-based encodings
    - Support for 8bit encodings that are not ASCII supersets (EBCDIC, etc.)
    - Possibly BOMful UTF-16 and -32
- Updating character data to current Unicode
- Wide stdio improvements
- Linux uapi updates
- Merging `strftime` extensions
- Debugging and merging `fopencookie` implementation
- Merging new internal lock implementation
- Debugging and fixing mips64 `utime` breakage
- Merging riscv port

# musl 1.1.20

Estimated release: Late January

Goals & Focus:

- Dynamic linker improvements:
    - Dependency ordering of dynamic-linked constructors
    - Resolving recursive `dlopen` locking issues
    - Code cleanup & deduplication
- Locale support polishing:
    - Handling for MON_5/ABMON_5 translation ambiguity ("May")
    - `LC_NUMERIC`, `LC_MONETARY`, and `LC_COLLATE` functionality
- Resolver support for non-ASCII domains (IDN)
- Using stdio buffer provided to `setvbuf`
- Adding `GLOB_TILDE` to glob implementation
- UB-correctness fixes including string functions and stdio


# Open future goals

- IEEE quad math correctness
- Complex math correctness Complex math correctness
- Enhanced LSB/glibc ABI-compat, especially fortify `__*_chk` symbols
- Remapping of glibc-ABI-incompatible symbols (regexec, etc.) by dynamic linker
- New `getlogin[_r]` with lookup via controlling tty
- Possible non-stub utmp backends
- ARM Cortex-M FDPIC ABI
- Resolving GCC symbol-versioning incompatibility issue - see
  <http://www.openwall.com/lists/musl/2015/05/10/1>
- Message translation support for dynamic linker


# Milestone goals for musl 1.2.0

The following tentative goals for what would constitute "musl 1.2.0" have been
established. There is no projected release date for 1.2.0 at this time.

- Cleanup & build system - **DONE**
    - Deduplication and asm-reduction of atomic operations
    - Deduplication of bits headers for archs
    - Support for out-of-tree builds
- Improved locale and multilingual support
    - `LC_COLLATE` support for collation orders other than simple codepoint order
    - Support for `LC_MONETARY` and `LC_NUMERIC` properties.
    - IDN support in DNS resolver
    - Character data aligned with current Unicode at time of release
- Porting
    - Aarch64 (64-bit ARM) port - **DONE**
    - RISC-V (32- and 64-bit) ports
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
    - External header-file-only fortify library providing `_FORTIFY_SOURCE`
      feature - **DONE**
    - Support for Windows targets via Midipix (<http://www.midipix.org>)
