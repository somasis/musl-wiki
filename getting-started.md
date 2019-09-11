# Getting started

To start using musl, you have three choices.

# Using the musl-gcc wrapper

This allows you to test and use musl on a glibc/uclibc system with no great
effort. You cannot, however, use C++ with it.

When building musl, there are 3 important flags to pass to configure:

- `--prefix=<path>`
    Where to install musl. A good choice is something like `$HOME/musl`.
- `--exec-prefix=<path>`
    This is where the musl-gcc wrapper gets installed to. It should point to
    somewhere in your `PATH`. A good choice is something like `$HOME/bin`.
- `--syslibdir=<path>`
    This is where the dynamic linker gets installed into. The default is `/lib`;
    this path will be baked into binaries built by musl-gcc, so you should not
    alter it if you want your dynamic binaries to be portable. Installing to
    `/lib` on most systems requires root privileges, so a typical choice for
    non-root users would be `$HOME/musl/lib`.

You can omit shared library support (static linking only) and cut musl's build
time in half using `--disable-shared`.

This configure run will generate a config.mak file, which contains your
settings.

Now run `make && make install`.

Now you can use `musl-gcc` instead of `gcc` to compile things against musl. Use
`-static` to build static binaries. For example, to compile a software package
that uses autoconf statically against musl:

```sh
CC="musl-gcc -static" ./configure --prefix=$HOME/musl && make
```

# Building a cross compiler targeting musl libc

Unofficial prebuilt cross compilers are available at
[musl.cc](https://musl.cc), or you can build them yourself (in about
10-15 minutes on a reasonably recent system) using
[musl-cross-make](https://github.com/richfelker/musl-cross-make/).
This gives you a full, relocatable musl-targeting toolchain, with C++
support and its own library paths you can install third-party
libraries into.

Whether building your own or downloading binaries, you need to select
the appropriate GCC-style tuple for the architecture/ABI you want to
target. It takes the form `[arch]-linux-musl[abi_modifiers]`. For
example, ARM is `arm-linux-musleabi` for standard soft-float EABI and
`arm-linux-musleabihf` for the hard-float variant. x86_64 is
`x86_64-linux-musl`. A fairly complete list of interesting tuple
patterns can be found in musl-cross-make's
[`README.md`](https://github.com/richfelker/musl-cross-make/blob/master/README.md).

If building your own toolchain with musl-cross-make,

```sh
make TARGET=x86_64-linux-musl install
```

will produce an x86_64-targeting toolchain in
`./output/x86_64-linux-musl` which you can then move to wherever you'd
like to keep it. Note that parallel make (`-jN`) is fully supported
and recommended as long as you have multiple cores and plenty ram.

## Notes on ARM Float Mode

Note: this information may be outdated or imprecise; it was converted
over from old instructions for the obsolete and unmaintained
"musl-cross" build scripts.

There are three float modes available on modern ARM SoC's:

- `soft` - floating point is completely emulated, very slow
- `softfp` - uses hardware floating point, but is ABI compatible with soft
- `hard` - complete hardware floating point, incompatible ABI with soft and
  softfp

On modern armv6 and armv7 chips, hardware floating point is usually implemented
on chip. To use the hard-float ABI variant, it suffices to include
"hf" at the end the target tuple's "ABI part" when building your
toolchain; musl-cross-make will automatically pick that up and pass
the right options to GCC's build process. For hard-float with the
standard baseline EABI ("softfp"), you need to pass custom
configuration options for gcc's build process, e.g.

```sh
make TARGET=arm-linux-musleabi GCC_CONFIG="--with-float=softfp --with-arch=armv6k --with-fpu=vfpv2" install
```

You can also specify custom gcc configure options just to set the
default ISA level so that you don't have to pass `-march=...`, e.g.

```sh
make TARGET=arm-linux-musleabihf GCC_CONFIG="--with-arch=armv7-a --with-fpu=vfpv3-d16" install
```

This should produce a cross-toolchain that is compatible at least with: Marvell
Dove, Freescale i.MX5x, TI OMAP3+4, Qualcomm Snapdragon, nVidia Tegra2+3 and
probably all other modern Cortex-A8, Cortex-A9 and Cortex-A15 SoC's on the
market.

If you plan to compile for older armv6 SoC's, like the one found on the
RasperryPi, use something like:

```sh
make TARGET=arm-linux-musleabihf GCC_CONFIG="--with-arch=armv6k --with-fpu=vfpv2" install
```

VFPv3 contains the VFPv2 subset, so you can also use the armv6
binaries on a more modern armv7 system, but losing some performance.
On contrary, for Cortex-A15 SoC's like the new Samsung Exynos 5, you
can activate the even more powerful VFPv4.

# Using a distro targeting musl

If your distro uses musl natively, then naturally, anything compiled on that
distro will use musl. Several distros using musl, such as sabotage, are listed
on the [Projects using musl page of this wiki][Projects using musl].

