# Writing Tests

Improving test coverage is one of the most valuable contributions you
can make to musl. Insufficient testing makes it hard to ensure that
new ports are correct, and hard to overhaul existing code.

The official test suite for musl is the libc-agnostic `libc-test`
repository, available at <http://nsz.repo.hu/git/?p=libc-test>.


## Tests needed

The following is an incomplete list of missing test coverage that
would be nice to have:

- `strftime` - Basic functional tests for all format specifiers,
  corner case values.

- `iconv` - Round trips to/from all supported character encodings.

- DNS stub resolver - User+mount+network namespace based tests to hook
  the resolver up to a fake nameserver listening on localhost:53.
  Should test malformed response packets (particularly forms that
  triggered bugs in the past), well-formed corner cases, 

- Unicode properties - Verify that the properties reported by
  `wcwidth` and the `wctype.h` `isw*` functions, and the case mappings
  performed by `towupper`/`towlower`, are consistent/reasonable with
  particular Unicode versions.

- UTF-8/16/32 encoders/decoders - Multibyte, `char16_t`, and
  `char32_t` functions accept and correctly convert all valid inputs,
  reject all invalid ones.

- `fmemopen`, `open_memstream`, and `open_wmemstream` - Line-by-line
  tests for the properties the POSIX spec requires. The musl
  implementations of these are all likely to have subtle conformance
  bugs.

- Arch bits & sycall conventions - Simple checks using all of the
  user/kernel boundary structures and syscalls that vary per arch
  (`stat`, etc.) to see that both sides are interpreting the data
  consistently.

- Environment manipulation functions - Various well-defined
  combinations of editing the environment via `environ[]`, `putenv`,
  `setenv`, and `unsetenv`, checking consistency of the results.

- `setjmp`/`longjmp`/`sigsetjmp`/`siglongjmp` - Use under conditions
  that are expected to have most/all registers in use and, for the
  `sig*` versions, where the correctness of signal mask
  saving/restoration is visible. Also that `fenv` is *not* restored by
  `longjmp`/`siglongjmp` (a common bug).

- `gettext` - Basic lookup functionality, domain binding, plural
  rules. Existing musl-specific `__pleval` tests could be reformulated
  as libc-agnostic using `.mo` files containing the plural rules.
