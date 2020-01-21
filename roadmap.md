# Roadmap

We aim to follow roughly a time-based release schedule. The roadmap describes likely
focus and goals for current and upcoming release cycles, but these may change in the
interest of keeping releases moving or meeting areas of user and developer interest.


# musl 1.2.0

Estimated release: Late January

Goals & Focus:

- 64-bit `time_t` on 32-bit archs
- Initial work on next-gen `malloc`, at first out-of-tree
- Unicode 12.1 update and related character handling work


# musl 1.2.1

Estimated release: February

- Integration of next-gen `malloc` implementation
- Reduction in asm source files, replacement with inline asm in C
  source files.


# musl 1.2.2

Estimated release: April 2020

- Removal of LFS64 APIs (not ABIs)
- Experimental no-`PT_INTERP` dynamic linking mode
- Locale support overhaul.
- Hostname resolver support for non-ASCII domains (IDN)
- ARM Cortex-M FDPIC ABI



# musl 1.1.25

On an as-needed basis, backport of post-1.1.24 fixes to
32-bit-`time_t` archs.



# Open future goals

- RISC-V 32-bit port
- `LC_COLLATE` support for collation orders other than simple codepoint order
- Support for `LC_MONETARY` and `LC_NUMERIC` properties.
- IEEE quad math correctness for archs with `long double` as quad
- Complex math correctness
- Floating point exception flags for soft-float archs
- Enhanced LSB/glibc ABI-compat, especially fortify `__*_chk` symbols
- Remapping of glibc-ABI-incompatible symbols (regexec, etc.) by dynamic linker
- New `getlogin[_r]` with lookup via controlling tty
- Possible non-stub utmp backends
- Resolving GCC symbol-versioning incompatibility issue - see
  <http://www.openwall.com/lists/musl/2015/05/10/1>
- Message translation support for dynamic linker
- Non-glibc-based nscd-protocol backend for LDAP (and perhaps NIS)
- Locale data and libc message translations


# Outstanding documentation goals

- Bringing existing documentation into alignment with changes made since
  1.0.0
- Documenting new and non-obsolescent extensions in detail
- Adapting text from wiki and other sources on properties of the
  implementation relevant to programmers and end users
