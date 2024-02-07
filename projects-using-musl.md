# Projects using musl

# Linux distributions using musl

- [Abyss] - An independent Linux distribution based on musl and pure LLVM.
- [Adélie Linux] - A small, independent Linux distribution focused on delivering a high quality
  operating environment, aiming for POSIX® compliance, compatibility with a wide variety of
  computers, and ease of use without sacrificing features.
- [Alpine Linux] - based on musl since the 3.0 release.
- [Ataraxia Linux] - Independent, multi-platform, general purpose operating system based on the
  Linux kernel and musl libc.
    - Supports 17 different CPU architectures
    - Has merged /usr for better compatibility
    - Extremely bleeding edge
    - Uses ZSTD where it's possible. Kernel, modules and initrd are using ZSTD by default.
- [Bedrock Linux] - as of version 1.0alpha4
- [bootstrap-linux] - consists only of a minimal set of packages that can be
  crosscompiled. kernel, toolchain, busybox.
- [Chimera Linux] - use musl, LLVM toolchain and FreeBSD userland with Linux kernel
- [Cross Linux From Scratch] - CLFS uses musl since 16.10.2013
  ([Announcement][CLFS-announcement])
- [Dragora] - An independent GNU/Linux-Libre distribution based on concepts of simplicity.
    - Contains 100% free software.  Musl is included in Dragora for the 3.0 series (back in 2012).
    - Per-package directories using qi (an own package manager) and graft following the GNU stow's spirit.
    - /usr merge, offering compatibility with the Filesystem Hierarchy Standard (FHS).
    - Uses sysvinit combined with perp for the supervision of critical services.
    - Supports several architectures via bootstrap, but is currently available for x86 (i586+), x86_64.
- [Embedded Linux From Scratch] - a fork of CLFS embedded using musl libc
    - 2013-09-28 Updated to correct name of toolchain used
    - 2013-09-14 Updated to musl-0.9.13. Supports \*-\*-musl\* toolchains.
- [EvolutionOS] uses musl for it's x86_64 images
- [Exherbo] has an x86_64 musl stage.
- [Gentoo] has stages for most architectures (has [musl overlay] for packages without mainline support yet)
    - <https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-musl/>
    - <https://distfiles.gentoo.org/releases/x86/autobuilds/current-stage3-i686-musl/>
    - <https://distfiles.gentoo.org/releases/arm/autobuilds/>
- [glaucus] - A simple and lightweight Linux® distribution based on musl libc and toybox
- [Iglunix] - An independent, self-hosting, Linux distribution with no GNU software
- [KISS Linux] - An independent Linux distribution with a focus on simplicity and the concept of
  "less is more".
- [Mere Linux]
    - Uses pacman for package management and s6 for process supervision
    - Contains instructions for bootstrapping LFS-style
- [morpheus] - suckless linux distro
- [oasis] - statically linked linux distribution based on musl and other lightweight components.
- [sabotage] - experimental Linux distribution based on busybox and musl.
    - About 700 packages including X11, LXDE, alsa, SDL, C++.
    - Supports i386, x86_64, arm, mips, powerpc
    - Uses lightweight replacements for netlink, pkg-config, and gettext
    - Optimized for build speed and small binary size
    - Per-package directories following stow/gobolinux spirit
- [Snowflake]
    - Includes only of a minimal set of packages that can be crosscompiled.
      (Kernel, toolchain, busybox, gawk, make and sed)
    - Uses pkgsrc for additional packages, so supports thousands of packages
    - Mainly a platform for testing usrview, a system for per-process views of
      /usr, for very fine-grained control of package management.
- [solyste] - statically linked linux distribution targetting embedded hardware and various
  architectures
- [Talos] - A modern Linux distribution for Kubernetes.
- [TAZ] - a Gentoo-based livecd/livedvd
- [Vanilla] - A radically different, new, simple, customizable Linux distribution based on musl,
  busybox using LLVM/Clang as toolchain.
- [Void Linux] provides official musl based images.

[Abyss]: https://github.com/abyss-os
[Adélie Linux]: https://adelielinux.org
[Alpine Linux]: https://alpinelinux.org/
[Ataraxia Linux]: https://github.com/ataraxialinux/ataraxia
[Bedrock Linux]: https://bedrocklinux.org/introduction.html
[bootstrap-linux]: https://github.com/pikhq/bootstrap-linux
[Chimera Linux]: https://chimera-linux.org/
[CLFS-announcement]: https://openwall.com/lists/musl/2013/10/16/1
[Cross Linux From Scratch]: https://clfs.org/
[Dragora]: https://dragora.org
[Embedded Linux From Scratch]: https://kanj.github.io/elfs/book/
[Exherbo]: https://www.exherbolinux.org/
[Gentoo]: https://www.gentoo.org/
[glaucus]: https://glaucuslinux.org/
[Iglunix]: https://iglunix.xyz/
[KISS Linux]: https://kisslinux.org/
[Mere Linux]: https://merelinux.org
[morpheus]: https://git.2f30.org/morpheus/
[oasis]: https://github.com/michaelforney/oasis
[sabotage]: http://sabo.xyz/
[Snowflake]: https://github.com/GregorR/snowflake
[solyste]: https://framagit.org/Ypnose/solyste
[Talos]: https://github.com/talos-systems/talos
[TAZ]: https://github.com/Sharrisii/TAZ
[Vanilla]: http://projects.malikania.fr/vanilla
[Void Linux]: https://voidlinux.org/

# Linux distros shipping musl as an optional package

- [Arch Linux]
- [Chromebrew] provides an official musl package.
- [Debian] package is available.
- [Fedora] package is available starting with Fedora 30.
- [Ubuntu] package is included in the universe section of the repository
  starting with Ubuntu 14.04 Trusty Tahr. There is also a PPA available
  (ppa:bortis/musl) for Saucy Salamander.
- [openadk] Embedded Linux buildsystem, musl can be selected as the libc of the
  system.
- [OpenWrt] packages musl and uses musl as default libc except for mips64 since
  [r45995].
- [Yocto] - OpenEmbeeded based Yocto Project supports generated embedded Linux distributions based on musl C library
    - Set TCLIBC = "musl" to switch default C library to musl for building embedded linux platforms
    - poky-tiny ( Yocto Project Reference Distribution ) is now based on musl
    - [Yoe] Distro - Fully supports Generating musl based images

[Arch Linux]: https://archlinux.org/packages/extra/x86_64/musl/
[Chromebrew]: https://chromebrew.github.io/
[Debian]: https://packages.debian.org/search?keywords=musl&searchon=names&suite=all&section=all
[Fedora]: https://src.fedoraproject.org/rpms/musl
[musl overlay]: https://gitweb.gentoo.org/proj/musl.git
[openadk]: https://openadk.org/
[OpenWrt]: https://openwrt.org/
[r45995]: https://dev.openwrt.org/changeset/45995
[Ubuntu]: http://packages.ubuntu.com/search?keywords=musl&searchon=names&suite=all&section=all
[Yocto]: https://www.yoctoproject.org/
[Yoe]: https://www.yoedistro.org/

# Other Projects

Third-party projects using or building on musl:

- [buildroot] toolchain has musl libc option
- [docker-muslbase] minimal musl-based docker container
- [Dwarf Fortress port]
- [ELLCC] is a Clang/LLVM and musl based cross compilation toolchain for
  embedded systems
- [Emscripten] is a LLVM-based compiler from C to C++ to JavaScript, using most
  of musl (some filesystem parts are written in JavaScript)
- [Firecracker VMM] is an open source virtualization technology that
  is purpose-built for creating and managing secure, multi-tenant
  container and function-based services.
- [Mirage OS] is an Xen guest written in OCaml, its floating-point formatting
  code is from musl.
- [Mission Pinball Framework] is an open source framework to program real
  pinball machines. It uses musl to cross-compile binaries for embedded
  targets such as Stern Spike.
- [mussel] The shortest and fastest script to build working cross compilers targeting musl libc
- [NodeOS] linux with Node.js as userspace
- [OSv] "cloud" operating system used a musl based libc
- [Rust] is a programming language with musl supported as a cross-compilation
  option
- [seL4] seL4 kernel ships with musl
- [simplecct] simple cross compiler toolchain
- [toybox] simple Unix command-line utilities

[buildroot]: https://buildroot.org/
[docker-muslbase]: https://github.com/mwcampbell/docker-muslbase
[Dwarf Fortress port]: https://openwall.com/lists/sabotage/2013/11/01/1
[ELLCC]: http://ellcc.org/
[Emscripten]: http://emscripten.org/
[Firecracker VMM]: https://firecracker-microvm.github.io/
[Mirage OS]: https://mirage.io/
[Mission Pinball Framework]: https://missionpinball.org/
[mussel]: https://github.com/firasuke/mussel
[NodeOS]: https://github.com/NodeOS/NodeOS
[OSv]: https://github.com/cloudius-systems/osv/
[Rust]: https://www.rust-lang.org/
[seL4]: https://github.com/seL4/musllibc
[simplecct]: https://code.google.com/p/simplecct/
[toybox]: https://landley.net/toybox/
