# Building LLVM

LLVM+Clang is a bit of a beast to build due to its size, the fact that it's
nearly all C++ and the number of its dependencies. It also tends to assume that
a Linux environment will either be Glibc-based or Android.

The following are notes and build instructions that have worked well for
building llvm against musl as of 2013-06-18. The instructions should work in any
musl and gcc based environment, but the notes below have been specifically
developed and tested in the [LightCube bootstrap environment]. If using that
environment, the instructions below assume you are chrooted into that
environment and are working as the root user in the /root directory. So even
though it is not explicitly stated, each section starts the commands off from
the perspective of root in /root.

[LightCube bootstrap environment]: https://github.com/jhuntwork/lightcube-bootstrap-musl

# Environment

Just set up a PM variable for use with make in order to have it take advantage
of multiple processors and build in parallel. The value should be the # of
processors the kernel is aware of.

```sh
export PM=$(grep -c processor /proc/cpuinfo)
```

Specific to the LightCube environment, add a /usr directory and some symlinks to
its top-level counterpart. An alternative to this would be to find and replace
all instances of /usr in the llvm codebase, which has not yet been tested:

```sh
install -d /usr
ln -s /{bin,sbin,include,man,share} /usr/
chmod 500 /usr
```

# Build cmake

```sh
curl -LO http://www.cmake.org/files/v2.8/cmake-2.8.11.1.tar.gz
tar -xf cmake-2.8.11.1.tar.gz
cd cmake-2.8.11.1
sed -i 's@__GNUC__@__GLIBC__@g' Source/kwsys/SystemInformation.cxx
./configure --prefix=/
make -j${PM}
make install
```

# Build libunwind

```sh
git clone --depth 1 git://github.com/pathscale/libunwind.git
mkdir libunwind-build
cd libunwind-build
cmake -DCMAKE_C_FLAGS="-m64" ../libunwind
make
cp -a src/libunwind.* /lib/
```

# Build llvm against libgcc/libstdc++

```sh
curl -LO https://gist.github.com/jhuntwork/5800888/raw/80538b7f5aaad6427e5f22d2428b9d644d2c93c8/llvm-musl_compat.patch
curl -LO https://gist.github.com/jhuntwork/5800919/raw/89b3fe54925888007ef4f9ec0906bffae1176979/compiler-rt-musl_compat.patch
curl -LO https://raw.github.com/path64/compiler/master/src/csu/elf-x86_64/crtbegin.S
curl -LO https://raw.github.com/path64/compiler/master/src/csu/elf-x86_64/crtend.S
git clone --depth 1 http://llvm.org/git/llvm
cd llvm
patch -Np1 -i ../llvm-musl_compat.patch
cd tools/
git clone --depth 1 http://llvm.org/git/clang
cd ../projects/
git clone --depth 1 http://llvm.org/git/compiler-rt
cd compiler-rt
patch -Np1 -i ../../../compiler-rt-musl_compat.patch
cd ..
git clone --depth 1 http://llvm.org/git/test-suite
cd ..
sed -i 's@/lib64/ld-linux-x86-64.so.2@/lib/ld-musl-x86_64.so.1@' tools/clang/lib/Driver/Tools.cpp
```

The below change sets the compiler up to avoid a hard-coded dependency on
libgcc. It will get most of the necessary symbols from libunwind instead.

```sh
sed -i -e 's@"-lgcc[^"]*"@"-lunwind"@g' tools/clang/lib/Driver/Tools.cpp
```

This change is specific to the binutils version used in the LightCube
environment. If using a newer version, the below should not be necessary

```sh
sed -i '/--build-id/s@.*@{}@' tools/clang/lib/Driver/ToolChains.cpp
```

The following two changes just set up our target description to be linux-musl
instead of linux-gnu throughout the llvm code:

```sh
sed -i -e 's/linux-gnu/linux-musl/g' -e 's@LIBC=gnu@LIBC=musl@' `find . -name "confi*.guess" -o -name "confi*.sub"`
sed -i 's@linux-gnu@linux-musl@g' `grep -lr linux-gnu .`
```

Setup the build directory and compile:

```sh
mkdir ../llvm-build
cd ../llvm-build
../llvm/configure --prefix=/ --enable-targets=host --disable-docs --enable-optimized
make VERBOSE=1 -j${PM}
make install
```

Add the Pathscale crtbegin* and crtend* files to avoid future dependency on gcc.

```sh
as ../crtbegin.S -o /lib/clang/3.4/crtbegin.o
ln /lib/clang/3.4/crtbegin.o /lib/clang/3.4/crtbeginS.o
ln /lib/clang/3.4/crtbegin.o /lib/clang/3.4/crtbeginT.o
as ../crtend.S -o /lib/clang/3.4/crtend.o
ln /lib/clang/3.4/crtend.o /lib/clang/3.4/crtendS.o
ln /lib/clang/3.4/crtend.o /lib/clang/3.4/crtendT.o
```

Perform a very basic sanity check

```sh
echo 'int main(){return 1;}' | clang++ -x c++ - -v -Wl,--verbose
```

# Build libcxxrt

This library will be replaced later with libcxxabi which performs the same
function, but requires libc++ to build which we don't have yet. llvm works
better with libcxxabi when using libc++, but libcxxrt is enough to build libc++
the first time around.

```sh
git clone --depth 1 git://github.com/pathscale/libcxxrt.git
mkdir libcxxrt-build
cd libcxxrt-build
CC="clang -fPIC" CXX="clang++ -fPIC" cmake ../libcxxrt
make
cp -a lib/libcxxrt.* /lib/
```

# Build libcxx against libcxxrt

```sh
curl -LO https://gist.github.com/jhuntwork/5805941/raw/5c80b24491c0c947e5e8ce178a44571b6b273ae9/libcxx-musl_compat.patch
git clone --depth 1 http://llvm.org/git/libcxx
cd libcxx
patch -Np1 -i ../libcxx-musl_compat.patch
mkdir ../libcxx-build
cd ../libcxx-build
CC="clang -fPIC" CXX="clang++ -fPIC -D__musl__" cmake -G "Unix Makefiles" \
-DLIBCXX_CXX_ABI=libcxxrt -DLIBCXX_LIBCXXRT_INCLUDE_PATHS="../libcxxrt/src" \
-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ ../libcxx
make
make install
```

# Build libcxxabi

```sh
curl -LO https://gist.github.com/jhuntwork/5805976/raw/110325d22d689a87727a03ebe8c5fee4bf45cede/libcxxabi.patch
git clone --depth 1 http://llvm.org/git/libcxxabi.git
cd libcxxabi
patch -Np1 -i ../libcxxabi.patch
cd lib
./buildit
cp -a libc++abi.* /lib
```

# Build libcxx against libcxxabi

Get rid of the build data from a previous run

```sh
rm -rf libcxx-build
mkdir libcxx-build
cd libcxx-build
```

Latest libcxxabi no longer has this header, so remove it from the libcxx list

```sh
sed -i 's/;cxa_demangle.h//' ../libcxx/CMakeLists.txt
```

Configure and build

```sh
CC="clang -fPIC" CXX="clang++ -fPIC -D__musl__" cmake -G "Unix Makefiles" \
-DLIBCXX_CXX_ABI=libcxxabi -DLIBCXX_LIBCXXABI_INCLUDE_PATHS="../libcxxabi/include " \
-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ ../libcxx
make install
```

# Rebuild llvm+clang against libcxx/libcxxabi

This should remove any dependency on gcc and libstdc++ First clean up remnants
of the previous build

```sh
rm -rf llvm-build
```

Next, make libcxx the default C++ library, instead of libstdc++

```sh
cd llvm
sed -i '/^  return ToolChain::CST_Libstdcxx/s@stdcxx@cxx@' tools/clang/lib/Driver/ToolChain.cpp
```

Build

```sh
mkdir ../llvm-build
cd ../llvm-build
CC=clang CXX="clang++ -stdlib=libc++" \
../llvm/configure --prefix=/ --enable-targets=host \
--disable-docs --enable-optimized --enable-libcpp
make VERBOSE=1 -j${PM}
make install
```

# Sanity check

```sh
echo 'int main(){return 1;}' | clang++ -x c++ - -v -Wl,--verbose
```

Move gcc/g++ out of the way (to a temporary location)

```sh
mkdir -p /tmp/gcc.bak/{bin,lib,include}
mv /bin/gcc /tmp/gcc.bak/bin/
mv /bin/g++ /tmp/gcc.bak/bin/
mv /lib/gcc /tmp/gcc.bak/lib/
mv /lib/libgomp* /tmp/gcc.bak/lib/
mv /lib/libstdc++.* /tmp/gcc.bak/lib/
mv /include/c++/4.2.4 /tmp/gcc.bak/include/
ln -sf clang /bin/cc
ln -sf clang++ /bin/c++
```

Another sanity check now without gcc around

```sh
echo 'int main(){return 1;}' | cc -x c - -v -Wl,--verbose
echo 'int main(){return 1;}' | c++ -x c++ - -v -Wl,--verbose
```

Lastly, as an ultimate sanity check, you could repeat the last section and
completely rebuild llvm+clang again. This will prove if the toolchain can build
itself successfully. When done, you can execute the included test suite:

```sh
make check-all
```

