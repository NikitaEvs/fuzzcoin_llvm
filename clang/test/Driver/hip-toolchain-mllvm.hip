// REQUIRES: x86-registered-target
// REQUIRES: amdgpu-registered-target

// Check only -Xoffload-linker -mllvm=* options are passed
// to device lld linker.
// -mllvm options are passed to clang only.

// RUN: %clang -### --target=x86_64-linux-gnu \
// RUN:   --cuda-gpu-arch=gfx803 --cuda-gpu-arch=gfx900 \
// RUN:   -mllvm -unroll-count=10 \
// RUN:   -Xoffload-linker -mllvm=-inline-threshold=100 \
// RUN:   %s 2>&1 | FileCheck %s

// RUN: %clang -### --target=x86_64-linux-gnu \
// RUN:   --cuda-gpu-arch=gfx803 --cuda-gpu-arch=gfx900 \
// RUN:   -mllvm -unroll-count=10 \
// RUN:   -Xoffload-linker -mllvm=-inline-threshold=100 \
// RUN:   %s 2>&1 | FileCheck -check-prefix=NEG %s

// RUN: %clang -### --target=x86_64-linux-gnu \
// RUN:   --cuda-gpu-arch=gfx803 --cuda-gpu-arch=gfx900 \
// RUN:   -fgpu-rdc -mllvm -unroll-count=10 \
// RUN:   -Xoffload-linker -mllvm=-inline-threshold=100 \
// RUN:   %s 2>&1 | FileCheck %s

// RUN: %clang -### --target=x86_64-linux-gnu \
// RUN:   --cuda-gpu-arch=gfx803 --cuda-gpu-arch=gfx900 \
// RUN:   -fgpu-rdc -mllvm -unroll-count=10 \
// RUN:   -Xoffload-linker -mllvm=-inline-threshold=100 \
// RUN:   %s 2>&1 | FileCheck -check-prefix=NEG %s

// CHECK: [[CLANG:".*clang.*"]] "-cc1" "-triple" "amdgcn-amd-amdhsa"
// CHECK-SAME: "-aux-triple" "x86_64-unknown-linux-gnu"
// CHECK-SAME: {{.*}} "-target-cpu" "gfx803"
// CHECK-SAME: {{.*}} "-mllvm" "-unroll-count=10" {{.*}}
// CHECK: [[LLD:".*lld.*"]] {{.*}}"-m" "elf64_amdgpu"{{.*}} "-plugin-opt=-inline-threshold=100"

// CHECK: [[CLANG]] "-cc1" "-triple" "amdgcn-amd-amdhsa"
// CHECK-SAME: "-aux-triple" "x86_64-unknown-linux-gnu"
// CHECK-SAME: {{.*}} "-target-cpu" "gfx900"
// CHECK-SAME: {{.*}} "-mllvm" "-unroll-count=10" {{.*}}
// CHECK: [[LLD:".*lld.*"]] {{.*}} "-plugin-opt=-inline-threshold=100"

// NEG-NOT: {{".*opt"}}
// NEG-NOT: {{".*llc"}}
// NEG-NOT: "-plugin-opt=-unroll-count=10"
// NEG-NOT: "-m" "elf_x86_64"{{.*}} "-plugin-opt=-inline-threshold=100"
