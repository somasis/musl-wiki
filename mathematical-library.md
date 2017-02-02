# Mathematical Library

# User documentation

The mathematical library follows Annex F of C99 and assumes floating-point
semantics according to Annex F.

Floating-point formats are assumed to be IEEE-754 binary32 format for float and
IEEE-754 binary64 for double.

Supported long double formats: IEEE-754 binary64 (ld64) and x86 80 bit extended
precision format (ld80) are fully supported and there is partial support for
IEEE-754 binary128 (ld128).

Supported arithmetics evaluations (provided by the underlying platform and
compiler) are FLT_EVAL_METHOD 0, 1 or 2 (when FLT_EVAL_METHOD!=0 the excess
precision and range should be handled according to the ISO C semantics: rounded
away at assingments and casts).

The four rounding modes (FE_TONEAREST, FE_UPWARD, FE_DOWNWARD, FE_TOWARDZERO)
are supported on all platforms with fenv support.

The five status flags (FE_INEXACT, FE_INVALID, FE_DIVBYZERO, FE_UNDERFLOW,
FE_OVERFLOW) are supported on all platforms with fenv support.

No additional classifications are provided beyond the five standard classes
(FP_NAN, FP_INFINITE, FP_ZERO, FP_SUBNORMAL, FP_NORMAL), in case of ld80 the
invalid representations are treated according to the x87 FPU (pseudo infinites,
nans and normals are classified as FP_NAN and pseudo subnormals are classified
as FP_NORMAL).

Errors are reported by raising floating-point status flags ie. math_errhandling
is set to MATH_ERREXCEPT on all platforms (errno is not set by math functions
and on platforms without IEEE 754 exception semantics there is no error
reporting).

There are no other predefined fenv settings than FE_DFL_ENV.

If the floating-point environment is changed in other ways than the provided
interfaces in fenv.h the behaviour of the library functions is undefined (eg.
changing the precision setting of the x87 fpu or unmasking floating-point
exceptions are not supported).

Status flags are raised correctly in default fenv except the inexact flag.
(inexact is only raised correctly when explicitly specified by ISO C, underflow
flag is handled correctly in all cases which is a stronger guarantee than the
requirement in Annex F)

At least the following functions give correctly rounded results (in all rounding
modes, the float, double and long double versions as well): ceil, copysign,
fabs, fdim, floor, fma, fmax, fmin, fmod, frexp, ldexp, logb, modf, nearbyint,
nextafter, nexttoward, rint, remainder, remquo, round, scalbln, scalbn, sqrt,
trunc.

Decimal conversion functions in stdlib.h and stdio.h are correctly rounded as
well.

Other functions should have small ulp error in nearest rounding mode and the
sign of zero should be correct. (the goal is < 1.5 ulp error, ie. the last bit
may be wrong, which is met for most commonly used functions, notable exceptions:
several complex functions, bessel functions, lgamma and tgamma functions and arc
hyperbolic functions)

Signaling nan is not supported (library functions handle it as quiet nan so they
may not raise the invalid flag properly)

Quiet nans are treated equally (there is only one logical nan value, it is
printed as "nan" or "-nan", the library otherwise does not care about the sign
and payload of nan)

Infinities are printed as "inf" and "-inf".

# Development documentation

## Overview

The source code of math functions are in three directories: src/math/,
src/complex/ and src/fenv/ (implementing math.h, complex.h and fenv.h APIs
respectively)

The relevant public header files are include/float.h, include/math.h,
include/complex.h, include/fenv.h and include/tgmath.h (they rely on arch
specific headers: arch/$ARCH/bits/float.h and arch/$ARCH/bits/fenv.h)

The implementation uses the src/internal/libm.h internal header.

Most other functions in the standard library don't use floating-point
arithmetics, the notable exceptions are decimal conversion functions: strtof,
strtod, strtold, printf, scanf. (Note that these conversion functions that don't
use global stdio buffers are async-signal-safe in musl, except scanf with %m
which calls malloc. No other async-signal-safe code in musl uses floating-point
arithmetics, this is important because in C11 the state of the fenv in a signal
handler is unspecified, one has to explicitly save, set to default and restore
the fenv in a signal handler if float code is used.)

A large part of the mathematical library is based on the freebsd libm, which is
in turn based on fdlibm. No effort was made to keep the integrity of the
original code, most of it needed heavy cleanups and rewrites. The numerical
algorithms and approximation methods are not changed in most cases though.
(Designing new algorithms requires additional tools and is more effort than
conformance cleanups).

Note that floating-point semantics is non-trivial and often misinterpreted or
misimplemented, some examples:

- gcc and clang do not handle FENV_ACCESS (explained below)
- gcc and clang do not compile relation operators correctly (quiet vs signaling
  comparisons, inconsistent behaviour on different target archs, broken -mieee
  and -mno-ieee flag)
- even experts misinterpret FLT_EVAL_METHOD==2 as "non-deterministic" excess
  precision, eventhough the excess precision semantics is well-defined (most
  relevant example is gcc spilling x87 registers at double precision by default
  instead of extended precision)
- various libraries/tools changing x87 precision setting to non-conformant
  value while still using libc calls (without solving the double-rounding issues
  because of the wider exponent range)
- gcc incorrectly rounds away excess precision at return in -std=c99 mode (annex
  F should be followed)
- gcc incorrectly handles decimal constants in FLT_EVAL_METHOD!=0
- valgrind does not handle extended precision properly, only emulates double
  precision fp, giving incorrect results on x86
- libgcc soft float only implements fenv with hw support, it should provide
  _Thread_local fenv state otherwise (C11)
- gcc does not always optimize union{double f; uint64_t i;} correctly (can
  generate very expensive spurious float load/store)

## Bit manipulation

It is often required to manipulate the bit representation of floating-point
numbers using integer arithmetics (mostly to avoid raising floating-point
exceptions or to do simple operations that is hard or slow with floating-point
arithmetics).

libm.h has historical macros for bit manipulations, the convention for new code
is using explicitly declared unions and the ldshape union in case of long
double. An example of typical bit manipulation code that accesses the sign and
exponent:

```c
#include <stdint.h>

/* return x if it's in (-2,1) otherwise 0, without raising invalid flag on nan */

double foo(double x)
{
    union {double f; uint64_t i;} u = {x};
    int e = u.i>>52 & 0x7ff;
    int s = u.i>>63;
    return e<0x3ff || (s && e==0x3ff) ? x : 0;
}

float foof(float x)
{
    union {float f; uint32_t i;} u = {x};
    int e = u.i>>23 & 0xff;
    int s = u.i>>31;
    return e<0x7f || (s && e==0x7f) ? x : 0;
}

#include <float.h>
#if LDBL_MANT_DIG == 53
long double fool(long double x) { return foo(x); }
#elif LDBL_MANT_DIG == 64 || LDBL_MANT_DIG == 113
#include "libm.h"
long double fool(long double x)
{
    kunion ldshape u = {x};
    int e = u.i.se & 0x7fff;
    int s = u.i.se>>15;
    return e<0x3fff || (s && e==0x3fff) ? x : 0;
}
#endif
```

On ld64 platforms all long double functions are mapped to double precision ones,
so only ld80 and ld128 requires explicit code (and when possible they are
treated together).

Note: since signaling nans are not supported (they would raise invalid exception
for !=) the foo function can be implemented without bit manipulation

```c
double foo(double x)
{
    if (x!=x) return 0;
    return x > -2 && x < 1 ? x : 0;
}
```

The union convention is used because other solutions would violate the C99
aliasing rules or could not be optimized easily. For float and double the unions
are explicit instead of typedefed somewhere because they are sufficiently short,
make the code self-contained and they should be portable to all platforms with
IEEE fp format. (There is one known exception: the arm floating-point
accelerator provided IEEE arithmetics with mixed endian double representation,
but arm oabi is not supported by musl)

The ldshape union is for ld80 and ld128 code and depends on byte order.

The bit operations and int arithmetics need to be done with care and awareness
about integer promotion rules, implementation-defined and undefined behaviours
of signed int arithmetics. The freebsd math code heavily relies on
implementation-defined behaviour (signed int representation, unsigned to signed
conversion, signed right shift) and even undefined behaviour (signed int
overflow, signed left shift). Such integer issues should be fixed, they are
considered to be bugs. The convention is to use uint32_t and uint64_t types for
bit manipulations to reduce surprises.

## Constants

Floating constants can have float, double or long double type, eg. 0.1f, 0.1 or
0.1L respectively.

The usual arithmetic conversion rules convert to the "largest" type used in an
expression, so the 'f' suffix should be used consistently for single precision
float expressions (missing the 'f' causes the expression to be evaluated at
double precision).

The 'L' suffix has to be used for long double constants that are not exactly
representible at double precision to avoid precision loss. For clarity the
convention in musl is to use 'L' consistently in long double context except for
trivial numbers (0.0, 1.0, 2.0, .5) where it is optional.

Using integers in a floating-point expression is fine, it will be converted to
the appropriate float type at translation time (eg. 2*x is just as good as
2.0f*x, however -0*x is not the same as -0.0*x).

Note that 0.1f and (float)0.1 has different meaning: if FLT_EVAL_METHOD==0 the
first is 0.1 rounded to float precision, the second is 0.1 rounded to double
precision and then rounded to float causing double-rounding issues (not in this
case, but eg (float)0x1.00000100000001p0) and raises floating-point status flags
(inexact in this case) if FENV_ACCESS is ON.

FLT_EVAL_METHOD!=0 means the evaluation precision and range of constants and
expressions can be higher than the that of the type ie 0.1f==0.1 may be true
(this is not implemented by gcc correctly as of gcc-4.8 and clang only supports
targets with FLT_EVAL_METHOD==0).

Note that a larger floating-point type can always represent all values of a
smaller one (so conversion to larger type can never cause precision loss).

Even if FENV_ACCESS is ON static initializers don't raise flags at runtime (the
constants are evaluated using the default fenv, ie round to nearest mode) so
'static const' variables are used for named consts when inexact flag and higher
precision representation should be avoided otherwise macros or explicit literal
is used.

The standard does not require correct rounding for decimal float constants (the
converted floating-point value can be the nearest or any neighbor of the nearest
representible number, but the recommended practice is correct rounding according
to nearest rounding mode), however hexfloats can represent all values of a type
exactly and unambigously, so the convention is to prefer hexfloat representation
in the math code internally especially when it makes the intention clearer (eg
0x1p52 instead of 4503599627370496.0). (In public header files they must not be
used as they are not C++ or C89 compatible).

There is another i386 specific gcc issue related to constants: gcc can recognize
special constants that are built into the x87 FPU (eg
3.141592653589793238462643383L) and load them from the FPU instead of memory,
however the FPU value depends on the current rounding mode, so in this rare case
static const values may not be correctly rounded to the nearest number in
non-nearest rounding mode. Musl supports non-nearest rounding modes, but library
results may be imprecise for functions that are not listed as correctly-rounded.

## Excess precision

In C, fp arithmetics and constants may be evaluated to a format that has greater
precision and range than the type of the operands as specified by
FLT_EVAL_METHOD. The mathematical library must be compiled with consistent and
well-defined evaluation method (FLT_EVAL_METHOD >= 0).

If FLT_EVAL_METHOD==0 then there is no excess precision and this is the most
common case. (This gives the IEEE semantics, clang does not even support other
values and gcc only supports other values on i386, where FLT_EVAL_METHOD==2 is
the default)

There is an additional issue on i386: the x87 FPU has a precision setting, it
can do arithmetics at extended precision (64bit precision and 16bit
sign+exponent) or at double precision (53bit precision and 16 bit sign+exponent)
or at single precision. On linux the default setting is extended precision and
changing it is not supported by musl. On other operating systems the default is
double precision (most notably on freebsd), so taking floating-point code from
other systems should be done with care. (The double precision setting provides
similar fp semantics to FLT_EVAL_METHOD==0, but there are still issues with the
wider exponent range and the extra precision of long double is lost)

The convention in musl is that when excess precision is not harmful use double_t
or float_t and use explicit cast or assignment when rounding away the excess
precision is important. (Rounding the result means extra load/store operations
on i386, on other architectures it is a no-op).

Argument passing is an assignment so excess precision is dropped there, but
return statement is not (this has changed in C11), so if the extra range or
precision is harmful then explicit cast or assignment should be used before
return (eg 'return 0x1p-1000*0x1p-1000;' is not ok for returning 0 with
underflow raised).

An important issue with FLT_EVAL_METHOD!=0 is double rounding: rounding an
infinite precision result into an intermediate format and then again into a
smaller precision format can give different result than a single rounding to the
smaller format in nearest rounding mode. (with the x87 double precision setting
the wider exponent range can still cause double rounding in the subnormal range
where the inmemory representation has smaller precision than the fp registers)

```c
    double x = 0.5 + 0x1p-50; // exact, no rounding
    x = x + 0x1p52;
```

On FLT_EVAL_METHOD==0 platforms x is set to 0x1p52+1, on i386 the addition is
evaluated to 0x1p52+0.5 (rounded to extended precision) and then this is rounded
again to double precision for the assignment to 0x1p52 (nearest rounding rule)

In non-nearest rounding mode double rounding cannot cause different results, but
it can cause the omission of the underflow flag:

```c
    (double)(0x1p-1070 + 0x1p-1000*0x1p-1000)
```

The result is inexact and subnormal, so it should raise the underflow flag, but
the multiplication does not underflow at extended precision and the addition is
first rounded to extended precision and then to double and the result of the
second rounding is exact subnormal.

Musl raises the underflow flag correctly so it needs to take special care when
the result is in the subnormal range.

## Fenv and error handling

Correctly rounded functions support all rounding modes and all math functions
support the exception flags other than inexact.

In some cases the rounding mode is changed (eg. fma), or the exception flags are
tested and cleared (eg. nearbyint) or exception flags are raised by some float
operation (many functions). This means the compiler most not treat surrounding
floating-point operations as sideeffect-free pure computations: they depend on
the current rounding mode and change the exception flags (depend on and modify
global fenv state).

To allow compilers to do fp optimizations, the standard invented the FENV_ACCESS
pragma:

```c
#pragma STDC FENV_ACCESS ON
#pragma STDC FENV_ACCESS OFF
```

The OFF state means the code does not access the fenv in any way, so various
reordering, constant folding and common subexpression elimination operations are
valid optimizations. The ON state means in the local scope the compiler must not
do such optimizations.

Neither gcc nor clang supports the FENV_ACCESS pragma, in which case they should
assume FENV_ACCESS ON for all code for safety, however both compilers assume
FENV_ACCESS OFF and do agressive fp optimizations which cannot be turned off.

For the gcc issues see <http://gcc.gnu.org/wiki/FloatingPointMath>

Various FENV_ACCESS issues with gcc and clang (can be worked around using
volatile hacks):

Constant folding exception raising code or code that depends on rounding mode
(incorrectly optimized to x = 0; y = INFINITY; z = 1;):

```c
#pragma STDC FENV_ACCESS ON
double x = 0x1p-1000*0x1p-1000; // raises underflow, depends on rounding-mode, -frounding-math does not fix it
double y = 0x1p1000*0x1p1000; // raises overflow, depends on rounding-mode, -frounding-math does not fix it
double z = 1 - 0x1p-100; // depends on rounding mode, -frounding-math fixes it
```

Common subexpression elimination with rounding-mode change (simplified fma
code: a + b is not recalculated):

```c
double x, a, b;
int r = fegetround();
fesetround(FE_TONEAREST);
/* ... */
x = a + b;
if (x == 0) {
    /* make sure the sign of zero is right */
    fesetround(r);
    x = a + b;
    return x;
}
```

Expression reordering (trunc: absx < 1 check is ordered before the calculation
of y omitting inexact exception):

```c
/* round to integer, raise inexact if not integer */
y = absx + 0x1p52 - 0x1p52;
if (absx < 1)
    return 0*x;
```

Expression reordering (old lrint code: converting the result of rint to long
is ordered after the fe* checks)

```c
fenv_t e;
long i;
feholdexcept(&e);
i = rint(x);
/* dont raise inexact on overflow */
if (fetestexcept(FE_INVALID))
    feclearexcept(FE_INEXACT);
feupdateenv(&e);
return i;
```

Whenever the optional FE_* macros are used in library code they should be
conditional (#ifdef FE_...) because some platform may not support them.

Musl does not provide errno based error handling, math_errhandling is
MATH_ERREXCEPT, so it's important that floating-point status flags are raised
correctly. The convention is not to use explicit feraiseexcept(flag) calls,
because math code should work even if the platform does not support fenv,
raising flags through function calls is slow and arithmetics usually raise flags
correctly anyway. The math code makes sure that exceptions are not raised
spuriously and exceptions are not omitted by using appropriate arithmetics.

A simple exception raising example: implement a function f that is odd, can be
approximated by x + x*x*x/2 + x^5*eps when x is small, otherwise return g(x).

```c
double f(double x)
{
    union {double f; uint64_t i;} u = {x};
    int e = u.i>>52 & 0x7ff;

    if (e < 0x3ff - 13) { /* |x| < 0x1p-13 */
    if (e < 0x3ff - 26) { /* |x| < 0x1p-26 */
    if (e == 0) { /* x is subnormal or zero */
    #pragma STDC FENV_ACCESS ON
    /* raise underflow if x!=0 */
    float unused = x;
    }
    /* do not fall through, x*x could raise underflow incorrectly */
    /* note: inexact flag is not supported */
    return x;
    }
    return x*(1 + x*x/2);
    }
    return g(x);
}
```

Unfortunately the unused variable is optimized away so the convention is to use
volatile hacks in such cases:

```c
    if (e == 0)
    /* raise underflow if x!=0 */
    FORCE_EVAL((float)x);
```

the FORCE_EVAL macro is defined in libm.h and does a volatile assignment which
is not optimized away by the compiler.

Usual exception raising methods (inexact and divbyzero rarely need special
arithmetics):

```c
// underflow for subnormal x
(float)x;
// underflow for |x| < 1, x!=0
(float)(0x1p-149f*x)
// overflow for |x| >= 2, |x|!=inf
(float)(0x1p127f*x)
// invalid for inf
(x-x);
0*x;
// invalid for any x except nan
(x-x)/(x-x);
// invalid
0.0f/0.0f;
```

FORCE_EVAL is used if the expression is only evaluated for its fenv sideeffects.
Sometimes more efficient code could be made without any store if the compilers
did not optimize away unused code. (Efficient in terms of code size, these are
usually the rare corner-cases so performance is not critical)

## Common formulas

Commonly used formulas throughout the mathematical library (some of them are
described in the Goldberg paper, what every computer scientist should know about
fp)

Using the exponent

```c
    union {double f; uint64_t i;} u = {x};
    int e = u.i>>52 & 0x7ff;
    if (e == 0x7ff) { /* +-inf or nan */ }
    if (e == 0x3ff + N) { /* 2^N <= |x| < 2^(N+1) */ }
    if (e == 0) { /* +-0 or subnormal x */ }
```

Exact add in nearest rounding mode: hi+lo == x+y exactly and hi ==
(double)(x+y), it assumes FLT_EVAL_METHOD==0 (otherwise double rounding can ruin
the exactness)

```c
    /* exact add, assumes exponent_x >= exponent_y, no overflow */
    hi = x + y;
    lo = y - (hi - x);
```

Exact mul in nearest rounding mode: hi+lo == x*y exactly and hi ==
(double)(x*y), it assumes FLT_EVAL_METHOD==0

```c
    /* exact mul, assumes no over/underflow */
    static const double c = 0x1p27 + 1;
    double cx, xh, xl, cy, yh, yl, hi, lo, x, y;

    cx = c*x;
    xh = x - cx + cx;
    xl = x - xh;
    cy = c*y;
    yh = y - cy + cy;
    yl = y - yh;
    hi = x*y;
    lo = (xh*yh - hi) + xh*yl + xl*yh + xl*yl;
```

Another method to get reasonably precise x*x is to zero out the low bits (hi+lo
has extra 26bit precision compared to (double)(x*x)):

```c
    union {double f; uint64_t i;} u = {x};
    u.i &= (uint64_t)-1<<27;
    hi = u.f*u.f;  // exact
    lo = (x+u.f)*(x-u.f); // inexact
```

Round to int in the current rounding mode (or round to fixed point value):

```c
    static const double_t toint = 1/EPSILON;
    // x >= 0, x < 0x1p52
    r1 = x + toint - toint;
    // |x| < 0x1p51, nearest rounding mode
    r2 = x + 1.5*toint - 1.5*toint;
```

where EPSILON is DBL_EPSILON (0x1p-52) or LDBL_EPSILON (0x1p-63 or 0x1p-112)
according to the FLT_EVAL_METHOD.

## Sign of zero

Musl tries to return zero with correct sign (this is important in functions
which may be used in complex code, because of branch cuts).

With simple arithmetics the sign of zero cannot be detected silently: 0.0 ==
-0.0 and in all context they are treated equally except for division (1/-0.0 ==
--inf, 1/0.0 == inf), but then the divbyzero flag is raised. The signbit macro
or-- bit manipulation can be used to get the sign silently.

To remove the sign of zero, x*x can be used if x==0, alternatively x+0 works too
except in downward rounding mode (-0.0+0 is -0.0 in downward rounding).

To create 0 with sign according to the sign of x, 0*x can be used if x is finite
(otherwise copysign(0,x) or signbit(x)?-0.0:0.0 can be used, since signbit is a
macro it is probably faster, nan may need special treatment).

## Complex

Currently some complex functions are dummy ones: naive implementation that may
give wildly incorrect result. The reason is that there are non-trivial special
cases, which are hard to handle correctly. (There are various papers on the
topic, eg. about branch cuts by William Kahan and about the implementation of
complex inverse trigonometric functions by Hull et al.)

The convention is to create complex numbers using the CMPLX(re,im) construct,
new in C11, because gcc does not support the _Imaginary type and turns

```c
x*I
```

into

```c
(x+0*I)*(0+I) = 0*x + x*I
```

So if x=inf then the result is nan+inf*I instead of inf*I and thus a+b*I cannot
be used to create complex numbers in general.
