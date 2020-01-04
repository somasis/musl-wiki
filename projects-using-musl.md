# Projects using musl

# Linux distributions using musl

- [sabotage] - experimental Linux distribution based on busybox and musl.
    - About 700 packages including X11, LXDE, alsa, SDL, C++.
    - Supports i386, x86_64, arm, mips, powerpc
    - Uses lightweight replacements for netlink, pkg-config, and gettext
    - Optimized for build speed and small binary size
    - Per-package directories following stow/gobolinux spirit
- [bootstrap-linux] - consists only of a minimal set of packages that can be
  crosscompiled. kernel, toolchain, busybox.
- [Mere Linux]
    - Uses pacman for package management and s6 for process supervision
    - Contains instructions for bootstrapping LFS-style
- [Snowflake]
    - Includes only of a minimal set of packages that can be crosscompiled.
      (Kernel, toolchain, busybox, gawk, make and sed)
    - Uses pkgsrc for additional packages, so supports thousands of packages
    - Mainly a platform for testing usrview, a system for per-process views of
      /usr, for very fine-grained control of package management.
- [TAZ] - a Gentoo-based livecd/livedvd
- [Embedded Linux From Scratch] - a fork of CLFS embedded using musl libc
    - 2013-09-28 Updated to correct name of toolchain used
    - 2013-09-14 Updated to musl-0.9.13. Supports \*-\*-musl\* toolchains.
- [Cross Linux From Scratch] - CLFS uses musl since 16.10.2013
  ([Announcement][CLFS-announcement])
- [morpheus] - suckless linux distro
- [Bedrock Linux] - as of version 1.0alpha4
- [Alpine Linux] - based on musl since the 3.0 release.
- [Void Linux] provides official musl based images.
- [Exherbo] has an x86_64 musl stage.
- [oasis] - statically linked linux distribution based on musl and other
  lightweight components.
- [Ataraxia Linux] - Fast and compact Linux distribution which uses musl libc and busybox userland tools.
    - About 300-400 packages including X11, Wayland, Mesa3D, ALSA, SDL, SDL2, rust and go
- [Talos] - A modern Linux distribution for Kubernetes.
- [Vanilla] - A radically different, new, simple, customizable Linux
  distribution based on musl, busybox using LLVM/Clang as toolchain.
- [Dragora] - An independent GNU/Linux-Libre distribution based on concepts of simplicity.
    - Contains 100% free software.  Musl is included in Dragora for the 3.0 series (back in 2012).
    - Per-package directories using qi (an own package manager) and graft following the GNU stow's spirit.
    - /usr merge, offering compatibility with the Filesystem Hierarchy Standard (FHS).
    - Uses sysvinit combined with perp for the supervision of critical services.
    - Supports several architectures via bootstrap, but is currently available for x86 (i586+), x86_64.
- [Abyss] - An independent Linux distribution based on musl and pure LLVM.

[sabotage]: http://sabotage.tech/
[bootstrap-linux]: https://github.com/pikhq/bootstrap-linux
[Mere Linux]: https://merelinux.org
[Snowflake]: https://bitbucket.org/GregorR/snowflake
[TAZ]: https://github.com/Sharrisii/TAZ
[Embedded Linux From Scratch]: http://kanj.github.io/elfs/book/
[Cross Linux From Scratch]: http://cross-lfs.org/view/clfs-embedded/
[morpheus]: http://git.2f30.org/morpheus/
[Bedrock Linux]: http://bedrocklinux.org/introduction.html
[Alpine Linux]: http://alpinelinux.org/
[Void Linux]: https://voidlinux.org/
[Exherbo]: http://www.exherbo.org/
[CLFS-announcement]: http://openwall.com/lists/musl/2013/10/16/1
[oasis]: https://github.com/michaelforney/oasis
[Ataraxia Linux]: https://ataraxialinux.github.io/
[Talos]: https://github.com/talos-systems/talos
[Vanilla]: http://projects.malikania.fr/vanilla
[Dragora]: https://dragora.org
[Abyss]: https://abyss.run

# Linux distros that plan to switch to musl

- [Aboriginal] - next major release will be based on musl

[Aboriginal]: http://landley.net/aboriginal/

# Linux distros shipping musl as an optional package

- [Gentoo] (see [musl overlay])
    - <http://distfiles.gentoo.org/experimental/amd64/>
    - <http://distfiles.gentoo.org/experimental/x86/musl/>
    - <http://distfiles.gentoo.org/experimental/arm/musl/>
- [Arch Linux]
- [Debian] package is available.
- [Ubuntu] package is included in the universe section of the repository
  starting with Ubuntu 14.04 Trusty Tahr. There is also a PPA available
  (ppa:bortis/musl) for Saucy Salamander.
- [OpenWrt] packages musl and uses musl as default libc except for mips64 since
  [r45995].
- [openadk] Embedded Linux buildsystem, musl can be selected as the libc of the
  system.
- [Chromebrew] provides an official musl package.

[Gentoo]: http://www.gentoo.org/
[musl overlay]: https://gitweb.gentoo.org/proj/musl.git
[Arch Linux]: https://www.archlinux.org/
[Debian]: http://packages.debian.org/search?keywords=musl&searchon=names&suite=all&section=all
[Ubuntu]: http://packages.ubuntu.com/search?keywords=musl&searchon=names&suite=all&section=all
[OpenWrt]: https://openwrt.org/
[r45995]: https://dev.openwrt.org/changeset/45995
[openadk]: http://openadk.org/
[Chromebrew]: https://skycocker.github.io/chromebrew/

# Other Projects

Third-party projects using or building on musl:

- [simplecct] simple cross compiler toolchain
- [ELLCC] is a Clang/LLVM and musl based cross compilation toolchain for
  embedded systems
- [Emscripten] is a LLVM-based compiler from C to C++ to JavaScript, using most
  of musl (some filesystem parts are written in JavaScript)
- [Dwarf Fortress port]
- [OSv] "cloud" operating system used a musl based libc
- [Mirage OS] is an Xen guest written in OCaml, its floating-point formatting
  code is from musl.
- [docker-muslbase] minimal musl-based docker container
- [buildroot] toolchain has musl libc option
- [seL4] seL4 kernel ships with musl
- [NodeOS] linux with Node.js as userspace
- [Rust] is a programming language with musl supported as a cross-compilation
  option
- [Firecracker VMM] is an open source virtualization technology that
  is purpose-built for creating and managing secure, multi-tenant
  container and function-based services.
- [Mission Pinball Framework] is an open source framework to program real
  pinball machines. It uses musl to cross-compile binaries for embedded
  targets such as Stern Spike.

[simplecct]: https://code.google.com/p/simplecct/
[ELLCC]: http://ellcc.org/
[ELK]: http://ellcc.org/viewvc/svn/ellcc/trunk/libecc/src/elk/
[Emscripten]: http://emscripten.org/
[Dwarf Fortress port]: http://openwall.com/lists/sabotage/2013/11/01/1
[OSv]: https://github.com/cloudius-systems/osv/
[Mirage OS]: http://www.openmirage.org/
[docker-muslbase]: https://github.com/mwcampbell/docker-muslbase
[buildroot]: http://buildroot.org/
[seL4]: https://github.com/seL4/libmuslc
[NodeOS]: https://github.com/NodeOS/NodeOS
[Rust]: http://www.rust-lang.org/
[Firecracker VMM]: https://firecracker-microvm.github.io/
[Mission Pinball Framework]: https://missionpinball.org/
