# ABI Cheat Sheet

The following are ABI register usage notes accumulated with
development and porting of musl to various archs:

## aarch64
- x30 lr
- x31 zr or pc

## arm
- r0-r3 args/ret
- r4-r11 saved
- r12 temp (ip scratch)
- r13 sp
- r14 lr
- r15 pc

## microblaze
- r0 zero
- r1 sp
- r2 ro sda
- r3-r4 ret
- r5-r10 args
- r11-12 temp
- r13 rw sda
- r14 syscall ret addr
- r15 function ret addr
- r16 break ret addr
- r17 exception ret addr
- r18 assembler temp
- r19-r20 saved
- r21 thread pointer
- r21-r31 saved

## mips
- $0 zero
- $1 at (assembler temp)
- $2-$3 ret (aka v0-v1)
- $4-$7 args (aka a0-a3)
- $8-$15 temp (aka t0-t7)
- $16-$23 saved (aka s0-s7)
- $24 temp (aka t8)
- $25 function call addr (aka t9)
- $26-$27 kernel use
- $28 gp, call-clobbered
- $29 sp
- $30 fp
- $31 ra

Source: http://www.inf.ed.ac.uk/teaching/courses/car/Notes/slide03.pdf

# or1k (OpenRISC)
- r0 zero
- r1 sp
- r2 fp
- r3-r8 args
- r9 lr
- r11,r12 retval (lo,hi)
- r10 thread pointer
- r14-r30(even) saved
- r13-r31(odd) temp

Source: openrisc-arch-1.1-rev0.pdf, p.335

## powerpc
- 0 temp
- 1 sp
- 2 toc (thread pointer)
- 3 ret, arg0
- 4-10 args
- 11-12 temp
- 13-31 saved
- lr (not gpr; use mtlr/mflr)
- 30 got
- 11 plt temp
- ctr plt temp

Sources: http://www.csd.uwo.ca/~mburrel/stuff/ppc-asm.html, http://devpit.org/wiki/Debugging_PowerPC_ELF_Binaries

## sh (SuperH)

- r0-r3 ret
- r2 struct ret addr
- r4-r7 args
- r8-r13 saved
- r12 gp (saved)
- r14 fp (saved)
- r15 sp
- pr lr
- gbr thread ptr

Source: http://www.st.com/st-web-ui/static/active/en/resource/technical/document/reference_manual/CD17839242.pdf, p.9
