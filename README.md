# Modified libfuzzer with generation of execution hashes 
Modified llvm-17 source tree for the DissFuzz project based on the [fuzzcoin project](https://taesoo.kim/pubs/2022/jang:fuzzcoin.pdf).

The llvm-17 source tree is taken from the version [17.0.1](https://github.com/llvm/llvm-project/releases/tag/llvmorg-17.0.1).

The execution hash functionality is taken from the [fuzzcoin project](https://github.com/daehee87/fuzzcoin-llvm). This code is modified and ported to the LLVM-17.

## Building modified compiler

The build [script](make_clang.sh) can be used to compile clang and export necessary binaries to the ```output``` directory.

```bash
./make_clang.sh <num-of-procs-to-build>
```

## Using modified compiler

After the build process you can access the compiler as the ```output/bin/clang++```. For example, you have a program ```test.cc``` with a function to fuzz:
```c++
#include <stddef.h>
#include <stdint.h>

bool FuzzMe(const uint8_t *Data, size_t DataSize) {
  return DataSize >= 3 && Data[0] == 'F' && Data[1] == 'U' && Data[2] == 'Z' &&
         Data[3] == 'Z'; // :(
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  FuzzMe(Data, Size);
  return 0;
}
```

Then you need to compile it with the modified compiler:
```bash
./output/bin/clang++ -g -fsanitize=address,fuzzer test.cc -o test
```

And finally, you can run the compiled program which generates file ```pofw``` containing execution hashes of each execution.


