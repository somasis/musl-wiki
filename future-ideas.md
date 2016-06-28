# Future Ideas

The following are future development ideas mostly outside the scope of
developing musl itself, but closely relevant to use of musl as a replacement for
glibc or uClibc.

# Fortify

glibc has a feature, _FORTIFY_SOURCE, which hardens programs against many common
security errors using a mix of special bounds-checking functions in libc and
macros and inline functions in the libc headers which use GCC features to track
known object sizes and provide information to the functions in libc.

Rather than developing and maintaining a corresponding feature in musl, we would
like to see a libc-agnostic _FORTIFY_SOURCE implementation built purely on GCC
features. It would be based on an alternate set of headers which use GCC's
#include_next feature to get the libc headers, then proceed to define macros
similar in spirit to glibc's, but using 100% inline functions rather than
support code in libc. This would eliminate all maintenance complexity of
coordinating with musl development and would allow them to be used with other
libcs (even on non-Linux systems) without modification.

At some point it may also be desirable to provide the __*_chk interfaces glibc
has, but this should be purely for the sake of supporting binaryware libraries
or applications, not for linking new applications against musl.

# mDNS and alternate hostname database backends

The inability to use mDNS (a multicast-DNS-based zero config system) with musl
has been raised as an issue by users in the past. On glibc, using mDNS is
accomplished with NSS; obviously musl does not have (or want) NSS.

In principle, however, musl is fully extensible to use alternate hostname
database backends in place of normal DNS. All that's needed is a daemon that
runs on localhost, speaks DNS, and translates the requests to whatever backend
is needed. However it's unclear whether there are any existing tools of this
form. Developing one, adapting an existing DNS proxy program, or documenting how
to setup an existing program that's already capable could be a nice future
project.

# NUMA

There is interest in having musl scale well to NUMA clusters; however the
requirements are not well understood and it is not clear how compatible they
would be with existing goals and requirements. In particular, having malloc work
well on NUMA is difficult and probably conflicts with minimum-fragmentation
goals. Some pthreads bookkeeping may be suboptimal, but whether the
suboptimality even matters depends on kernel behavior that is not
well-understood.

