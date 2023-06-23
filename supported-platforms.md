# Supported Platforms

The target platforms (operating system, compiler toolchain, instruction set) on
top of which musl is known to work.

# Supported OS

musl is built on the Linux syscall layer. Linux kernel >=2.6.39 is necessary for
POSIX conformant behaviour, older kernels will work with varying degrees of
non-conformance, 2.4 kernels will only work for simple single-threaded
applications.

# Supported target architectures (ABIs)

- x86 (SysV ABI)
- x86_64 (SysV ABI)
- arm eabi (armv4t or later, requires gcc >= 4.2.4 for softfp, gcc >= 4.5.4 for
  hardfloat)
- aarch64
- m68k
- mips/mipsel o32 (MIPS1 with kernel emulation of ll and sc instructions, or
  MIPS2 or later, softfloat is supported as well)
- mips n32
- mips n64
- microblaze (~~needs toolchain from xilinx, [xilinx gitweb]~~ needs gcc >= 4.8
  (you can use musl-cross)) and linux 3.13 or [this patch].
- powerpc (needs gcc built with --enable-secureplt --with-long-double-64, and
  -Wl,--secure-plt to link dynamic binaries.)
- powerpc64
- x32 (experimental, due to a number of kernel issues) - requires GCC 4.7 or
  later (musl-cross is already capable of building a toolchain), you need at
  least linux 3.4, but note that there were [security issues].
- openrisc 1000
- s390x
- sh (experimental) with sh, sheb, sh-nofpu, and sheb-nofpu subarchs (currently
  this [kernel-patch] is required for multithread usage)
- riscv64 ( support added since 1.1.23 release ) currently softfp,
  single-precision, double-precision floating point supported

[ABI/ASM manuals][ABI Manuals]

[xilinx gitweb]: http://git.xilinx.com/?p=microblaze-gnu.git
[this patch]: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=99399545d62533b4ae742190b5c6b11f7a5826d9
[security issues]: http://seclists.org/oss-sec/2014/q1/187
[kernel-patch]: https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/arch/sh?id=a37922c1a80663dfb814f3837dc1f2a451707e5f

# Supported Compilers

Any conformant C and C++ compiler should be able to use musl (to compile and
link application code).

As of 2013-09-29, the following compilers are known to be able to compile musl:

- GCC (>=3.4.6)
    - started with gcc 4.8.1, [the memset code will be miscompiled][miscompile].
      This can be worked around by adding -fno-tree-loop-distribute-patterns to
      the CFLAGS or passing --enable-optimize=size to configure.
    - [musl-cross] provides prebuilt cross-compiler toolchains and
      cross-compiler build instructions.
    - GCC is officially supported using the musl-gcc wrapper or the musl-cross
      project (for details see [Getting started]).
- Clang (>=3.2)
    - [Instructions for Building LLVM+Clang against musl][Building LLVM]
    - <http://ellcc.org/> ELLCC is a Clang and musl based cross-compiler
      toolchain for embedded development.
- PCC (>=1.1.0.DEVEL)
- [CParser/firm]
    - configure musl with --disable-shared, since firm does not yet have
      position-independent code generation.

[miscompile]: http://openwall.com/lists/musl/2013/08/01/1
[musl-cross]: http://bitbucket.org/GregorR/musl-cross

[CParser/firm]: http://pp.ipd.kit.edu/firm/

# Further Information

Bootstrapping a working qemu development environment for microblaze is hard,
[here][microblaze-qemu] are the needed steps to do so.

See [Porting] for information on how to port musl to a new architecture.

[microblaze-qemu]: http://blog.waldemar-brodkorb.de/index.php?/archives/10-qemu-microblaze-system-emulation-tipps.html
