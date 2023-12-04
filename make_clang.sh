#!/bin/bash
N=`nproc`
if [ $# -gt 0 ]; then
	N="$1"
fi

echo using $N cores...

mkdir -p build
cd build
cmake -G "Ninja" \
    -DCMAKE_BUILD_TYPE="MinSizeRel" \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    -DLLVM_ENABLE_PROJECTS="compiler-rt;clang" \
	-DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
    ../llvm

make -j$N

cd ..
mkdir -p output/bin
cp build/bin/clang++ output/bin/
cp -r build/lib output/

