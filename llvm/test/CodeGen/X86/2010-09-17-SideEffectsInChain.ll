; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mcpu=core2 | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
declare void @llvm.memcpy.p0.p0.i64(ptr nocapture, ptr nocapture, i64, i1) nounwind

define fastcc i32 @cli_magic_scandesc(ptr %in) nounwind ssp {
; CHECK-LABEL: cli_magic_scandesc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subq $72, %rsp
; CHECK-NEXT:    movq __stack_chk_guard(%rip), %rax
; CHECK-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movzbl (%rsp), %eax
; CHECK-NEXT:    movzbl {{[0-9]+}}(%rsp), %ecx
; CHECK-NEXT:    movq (%rdi), %rdx
; CHECK-NEXT:    movq 8(%rdi), %rsi
; CHECK-NEXT:    movq %rdx, (%rsp)
; CHECK-NEXT:    movq 24(%rdi), %rdx
; CHECK-NEXT:    movq %rdx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rsi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq 16(%rdi), %rdx
; CHECK-NEXT:    movq %rdx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq 32(%rdi), %rdx
; CHECK-NEXT:    movq %rdx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq 40(%rdi), %rdx
; CHECK-NEXT:    movq %rdx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq 48(%rdi), %rdx
; CHECK-NEXT:    movq %rdx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq 56(%rdi), %rdx
; CHECK-NEXT:    movq %rdx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb %al, (%rsp)
; CHECK-NEXT:    movb %cl, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq __stack_chk_guard(%rip), %rax
; CHECK-NEXT:    cmpq {{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    addq $72, %rsp
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_2: # %entry
; CHECK-NEXT:    callq __stack_chk_fail@PLT
entry:
  %a = alloca [64 x i8]
  %c = getelementptr inbounds [64 x i8], ptr %a, i64 0, i32 30
  %d = load i8, ptr %a, align 8
  %e = load i8, ptr %c, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %a, ptr align 8 %in, i64 64, i1 false) nounwind
  store i8 %d, ptr %a, align 8
  store i8 %e, ptr %c, align 8
  ret i32 0
}

!llvm.module.flags = !{!0}
!0 = !{i32 7, !"direct-access-external-data", i32 1}
