# Roadmap

We aim to follow roughly a time-based release schedule. The roadmap describes likely
focus and goals for current and upcoming release cycles, but these may change in the
interest of keeping releases moving or meeting areas of user and developer interest.


# musl 1.1.23

Estimated release: Mid July

Goals & Focus:

- Merging riscv port
- Merging new math library implementations.

    
# musl 1.1.24

Estimated release: Late August

Goals & Focus:

- Attempted removal of LFS64 APIs (not ABIs)
- Working (non-stub) `catgets` implementation
- Experimental no-`PT_INTERP` dynamic linking mode
- Initial work on converting 32-bit archs to 64-bit `time_t`
- Initial work on next-gen `malloc`, at first out-of-tree


# musl 1.1.25

Estimated release: October

- 64-bit `time_t` on 32-bit archs
- Hostname resolver support for non-ASCII domains (IDN)
- ARM Cortex-M FDPIC ABI


# musl 1.1.26

Estimated release: December

- Next-gen `malloc` implementation
- Locale support overhaul.




# Open future goals

- IEEE quad math correctness
- Complex math correctness
- Enhanced LSB/glibc ABI-compat, especially fortify `__*_chk` symbols
- Remapping of glibc-ABI-incompatible symbols (regexec, etc.) by dynamic linker
- New `getlogin[_r]` with lookup via controlling tty
- Possible non-stub utmp backends
- Resolving GCC symbol-versioning incompatibility issue - see
  <http://www.openwall.com/lists/musl/2015/05/10/1>
- Message translation support for dynamic linker
- Adding `GLOB_TILDE` to glob implementation


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
