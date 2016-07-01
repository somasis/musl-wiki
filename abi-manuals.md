# ABI Manuals

Documentation describing the ABI and assembler manuals for the
architectures supported by musl.

Feel free to add links to the missing manuals.

- **x86**: ABI ASM

- **x86\_64**: [ABI][x86_64-ABI] [ABI][x86_64-ABI-ASM] ASM

- **x86\_64-x32** ABI

- **arm** EABI [ASM][arm-ASM]

- **aarch64** EABI [ASM][aarch64-ASM]

- **mips** [OABI][mips-OABI] [ASM][mips-ASM]

- **powerpc** [ABI][powerpc-ABI] ASM

- **microblaze** ABI ASM

- **superh** ABI [ASM][superh-ABI]

- **or1k** ABI ASM

a list of links to further SysV ABI documentation can be found [here][sysv-ABI].
they've not yet been confirmed to match the ABI used by linux/musl.

[GCC Inline asm] [GCC powerpc inline asm notes]

[x86_64-ABI]: http://refspecs.linuxfoundation.org/elf/x86_64-abi-0.95.pdf
[x86_64-ABI-ASM]: http://www.x86-64.org/documentation/abi.pdf
[arm-ASM]: http://www.scribd.com/doc/54697503/DDI0406B-Arm-Architecture-Reference-Manual-Errata-Markup-8-0
[aarch64-ASM]: http://www.cs.utexas.edu/~peterson/arm/DDI0487A_a_armv8_arm_errata.pdf
[mips-OABI]: http://refspecs.linuxbase.org/elf/mipsabi.pdf
[mips-ASM]: http://www.tik.ee.ethz.ch/education/lectures/TI1/materials/assemblylanguageprogdoc.pdf
[powerpc-ABI]: http://refspecs.linuxbase.org/elf/elfspec_ppc.pdf
[superh-ASM]: http://documentation.renesas.com/doc/products/mpumcu/rej09b0003_sh4a.pdf
[sysv-ABI]: http://wiki.osdev.org/System_V_ABI#Documents
[GCC Inline asm]: https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html
[GCC powerpc inline asm notes]: https://confluence.slac.stanford.edu/display/CCI/GCC+inline+assembler+code+notes+for+PowerPC
