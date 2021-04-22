# Projects using musl

# Linux distributions using musl

- [Abyss] - An independent Linux distribution based on musl and pure LLVM.
- [Adélie Linux] - A small, independent Linux distribution focused on delivering a high quality
  operating environment, aiming for POSIX® compliance, compatibility with a wide variety of
  computers, and ease of use without sacrificing features.
- [Alpine Linux] - based on musl since the 3.0 release.
- [Ataraxia Linux] - Independent, multi-platform, general purpose operating system based on the Linux kernel and musl libc.
    - Supports 17 different CPU architectures
    - Has merged /usr for better compatibility
    - Extremely bleeding edge
    - Uses ZSTD where it's possible. Kernel, modules and initrd are using ZSTD by default.
- [Bedrock Linux] - as of version 1.0alpha4
- [bootstrap-linux] - consists only of a minimal set of packages that can be
  crosscompiled. kernel, toolchain, busybox.
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
- [Exherbo] has an x86_64 musl stage.
- [glaucus] - An independent, open-source, general-purpose, bleeding-edge, rolling-release, source-based Linux® distribution based on musl libc and toybox, built from scratch around the suckless philosophy without sacrificing convenience.
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
- [solyste] - statically linked linux distribution targetting embedded hardware and various architectures
- [Talos] - A modern Linux distribution for Kubernetes.
- [TAZ] - a Gentoo-based livecd/livedvd
- [Vanilla] - A radically different, new, simple, customizable Linux distribution based on musl, busybox using LLVM/Clang as toolchain.
- [Void Linux] provides official musl based images.

[Abyss]: https://abyss.run
[Adélie Linux]: https://adelielinux.org
[Alpine Linux]: http://alpinelinux.org/
[Ataraxia Linux]: https://ataraxialinux.github.io/
[Bedrock Linux]: http://bedrocklinux.org/introduction.html
[bootstrap-linux]: https://github.com/pikhq/bootstrap-linux
[CLFS-announcement]: http://openwall.com/lists/musl/2013/10/16/1
[Cross Linux From Scratch]: http://cross-lfs.org/view/clfs-embedded/
[Dragora]: https://dragora.org
[Embedded Linux From Scratch]: http://kanj.github.io/elfs/book/
[Exherbo]: http://www.exherbo.org/
[glaucus]: https://www.glaucuslinux.org/
[Mere Linux]: https://merelinux.org
[morpheus]: http://git.2f30.org/morpheus/
[oasis]: https://github.com/michaelforney/oasis
[sabotage]: http://sabo.xyz/
[Snowflake]: https://github.com/GregorR/snowflake
[solyste]: https://framagit.org/Ypnose/solyste
[Talos]: https://github.com/talos-systems/talos
[TAZ]: https://github.com/Sharrisii/TAZ
[Vanilla]: http://projects.malikania.fr/vanilla
[Void Linux]: https://voidlinux.org/

# Linux distros that plan to switch to musl

- [Aboriginal] - next major release will be based on musl

[Aboriginal]: http://landley.net/aboriginal/

# Linux distros shipping musl as an optional package

- [Arch Linux]
- [Chromebrew] provides an official musl package.
- [Debian] package is available.
- [Fedora] package is available starting with Fedora 30.
- [Gentoo] (see [musl overlay])
    - <http://distfiles.gentoo.org/experimental/amd64/>
    - <http://distfiles.gentoo.org/experimental/x86/musl/>
    - <http://distfiles.gentoo.org/experimental/arm/musl/>
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

[Arch Linux]: https://www.archlinux.org/
[Chromebrew]: https://skycocker.github.io/chromebrew/
[Debian]: http://packages.debian.org/search?keywords=musl&searchon=names&suite=all&section=all
[Fedora]: https://src.fedoraproject.org/rpms/musl
[Gentoo]: http://www.gentoo.org/
[musl overlay]: https://gitweb.gentoo.org/proj/musl.git
[openadk]: http://openadk.org/
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

[buildroot]: http://buildroot.org/
[docker-muslbase]: https://github.com/mwcampbell/docker-muslbase
[Dwarf Fortress port]: http://openwall.com/lists/sabotage/2013/11/01/1
[ELLCC]: http://ellcc.org/
[Emscripten]: http://emscripten.org/
[Firecracker VMM]: https://firecracker-microvm.github.io/
[Mirage OS]: http://www.openmirage.org/
[Mission Pinball Framework]: https://missionpinball.org/
[mussel]: https://github.com/firasuke/mussel
[NodeOS]: https://github.com/NodeOS/NodeOS
[OSv]: https://github.com/cloudius-systems/osv/
[Rust]: http://www.rust-lang.org/
[seL4]: https://github.com/seL4/libmuslc
[simplecct]: https://code.google.com/p/simplecct/
