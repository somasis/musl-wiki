# Porting/AArch64

This page is intended to collect relevant information on the AArch64
architecture. AArch64 is the 64bit architecture first released as part of the
armv8 design.

# Reference documents

## Procedure Call Standards

- Procedure Call Standard for ARM 64-bit Architecture (AArch64):
  <http://infocenter.arm.com/help/topic/com.arm.doc.ihi0055b/IHI0055B_aapcs64.pdf>
- Procedure Call Standard for the ARM Architecture (AArch32):
  <http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf>

## ELF

- ELF for the ARM 64-bit Architecture (AArch64):
  <http://infocenter.arm.com/help/topic/com.arm.doc.ihi0056a/IHI0056A_aaelf64.pdf>

## Instruction set

- ARMv8-A Architecture Reference Manual:
  <http://infocenter.arm.com/help/topic/com.arm.doc.ddi0487a.b/index.html>
  (requires registration)
- ARM v8 Instruction Set Architecture:
  <http://infocenter.arm.com/help/topic/com.arm.doc.genc010197a/index.html>
  (requires registration)

## Other resources

- [linaro armv8](http://www.linaro.org/engineering/engineering-projects/armv8)
- [linaro downloads](http://www.linaro.org/downloads/)
- [debian arm64 port wiki](https://wiki.debian.org/Arm64Port)
- [prebuilt qemu userspace emulator](https://wiki.debian.org/Arm64Qemu)
- [gem5 full system simulator for armv8](http://gem5.org/Documentation)

There are 2 official proprietary emulators called Versatile Express "fast model"
and "foundation model". The latter is available for free after registering on
the ARM website.

## toolchain

Use Rich Felker's [musl-cross-make] and just set ARCH to aarch64 to
build the stage1 toolchain for testing (build errors will happen as soon as
stage1 gcc is compiled and kernel headers are installed, that is expected.)

[musl-cross-make]: https://github.com/richfelker/musl-cross-make
