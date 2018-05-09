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

Use the pre-built cross compilers at [musl-cross] or built it yourself using the
supplied scripts ([git mirror][musl-cross-git]). This gives you a full musl
toolchain, including C++ support. Note that although the scripts are capable of
building compilers targeting other architectures, a cross compiler targeting
your host architecture with musl libc is also useful, as the whole toolchain is
aware of its target libc.

[musl-cross]: https://bitbucket.org/GregorR/musl-cross/downloads
[musl-cross-git]: https://github.com/GregorR/musl-cross

## Notes on ARM Float Mode

There are three float modes available on modern ARM SoC's:

- `soft` - floating point is completely emulated, very slow
- `softfp` - uses hardware floating point, but is ABI compatible with soft
- `hard` - complete hardware floating point, incompatible ABI with soft and
  softfp

On modern armv6 and armv7 chips, hardware floating point is usually implemented
on chip. If someone is planing to compile musl-cross with hardware floating
point, add the following to your config.sh:

```sh
ARCH=arm
TRIPLE=arm-linux-musleabihf
GCC_BOOTSTRAP_CONFFLAGS="--with-arch=armv7-a --with-float=hard --with-fpu=vfpv3-d16"
GCC_CONFFLAGS="--with-arch=armv7-a --with-float=hard --with-fpu=vfpv3-d16"
```

This should produce a cross-toolchain that is compatible at least with: Marvell
Dove, Freescale i.MX5x, TI OMAP3+4, Qualcomm Snapdragon, nVidia Tegra2+3 and
probably all other modern Cortex-A8, Cortex-A9 and Cortex-A15 SoC's on the
market. If you plan to compile for older armv6 SoC's, like the one found on the
RasperryPi, use `--with-arch=armv6-a --with-float=hard --with-fpu=vfpv2`. VFPv3
contains the VFPv2 subset, so you can also use the armv6 binaries on a more
modern armv7 system, but losing some performance. On contrary, for Cortex-A15
SoC's like the new Samsung Exynos 5, you can activate the even more powerful
VFPv4.

# Using a distro targeting musl

If your distro uses musl natively, then naturally, anything compiled on that
distro will use musl. Several distros using musl, such as sabotage, are listed
on the [Projects using musl page of this wiki][Projects using musl].

