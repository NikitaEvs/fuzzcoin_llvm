//===-- Unittests for isatty ----------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "src/errno/libc_errno.h"
#include "src/fcntl/open.h"
#include "src/unistd/close.h"
#include "src/unistd/isatty.h"
#include "test/UnitTest/ErrnoSetterMatcher.h"
#include "test/UnitTest/Test.h"

using __llvm_libc::testing::ErrnoSetterMatcher::Fails;
using __llvm_libc::testing::ErrnoSetterMatcher::Succeeds;

TEST(LlvmLibcIsATTYTest, StdInOutTests) {
  // If stdin is connected to a terminal, assume that all of the standard i/o
  // fds are.
  libc_errno = 0;
  if (__llvm_libc::isatty(0)) {
    EXPECT_THAT(__llvm_libc::isatty(0), Succeeds(1)); // stdin
    EXPECT_THAT(__llvm_libc::isatty(1), Succeeds(1)); // stdout
    EXPECT_THAT(__llvm_libc::isatty(2), Succeeds(1)); // stderr
  } else {
    EXPECT_THAT(__llvm_libc::isatty(0), Fails(ENOTTY, 0)); // stdin
    EXPECT_THAT(__llvm_libc::isatty(1), Fails(ENOTTY, 0)); // stdout
    EXPECT_THAT(__llvm_libc::isatty(2), Fails(ENOTTY, 0)); // stderr
  }
}

TEST(LlvmLibcIsATTYTest, BadFdTest) {
  libc_errno = 0;
  EXPECT_THAT(__llvm_libc::isatty(-1), Fails(EBADF, 0)); // invalid fd
}

TEST(LlvmLibcIsATTYTest, DevTTYTest) {
  constexpr const char *TTY_FILE = "/dev/tty";
  libc_errno = 0;
  int fd = __llvm_libc::open(TTY_FILE, O_RDONLY);
  if (fd > 0) {
    ASSERT_EQ(libc_errno, 0);
    EXPECT_THAT(__llvm_libc::isatty(fd), Succeeds(1));
    ASSERT_THAT(__llvm_libc::close(fd), Succeeds(0));
  }
}

TEST(LlvmLibcIsATTYTest, FileTest) {
  constexpr const char *TEST_FILE = "testdata/isatty.test";
  libc_errno = 0;
  int fd = __llvm_libc::open(TEST_FILE, O_WRONLY | O_CREAT, S_IRWXU);
  ASSERT_EQ(libc_errno, 0);
  ASSERT_GT(fd, 0);
  EXPECT_THAT(__llvm_libc::isatty(fd), Fails(ENOTTY, 0));
  ASSERT_THAT(__llvm_libc::close(fd), Succeeds(0));
}
