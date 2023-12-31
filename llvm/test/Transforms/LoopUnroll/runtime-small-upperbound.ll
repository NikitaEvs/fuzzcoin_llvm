; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=loop-unroll -unroll-runtime %s -o - | FileCheck %s
; RUN: opt -S -passes=loop-unroll -unroll-runtime -unroll-max-upperbound=6 %s -o - | FileCheck %s --check-prefix=UPPER

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"

@global = dso_local local_unnamed_addr global i32 0, align 4
@global.1 = dso_local local_unnamed_addr global ptr null, align 4

; Check that loop in hoge_3, with a runtime upperbound of 3, is not unrolled.
define dso_local void @hoge_3(i8 %arg) {
; CHECK-LABEL: @hoge_3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr @global, align 4
; CHECK-NEXT:    [[Y:%.*]] = load ptr, ptr @global.1, align 4
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[X]], 17
; CHECK-NEXT:    br i1 [[TMP0]], label [[LOOP_PREHEADER:%.*]], label [[EXIT:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ [[IV_NEXT:%.*]], [[LOOP]] ], [ [[X]], [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[PTR:%.*]] = phi ptr [ [[PTR_NEXT:%.*]], [[LOOP]] ], [ [[Y]], [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i32 [[IV]], 8
; CHECK-NEXT:    [[PTR_NEXT]] = getelementptr inbounds i8, ptr [[PTR]], i32 1
; CHECK-NEXT:    store i8 [[ARG:%.*]], ptr [[PTR_NEXT]], align 1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[IV_NEXT]], 17
; CHECK-NEXT:    br i1 [[TMP1]], label [[LOOP]], label [[EXIT_LOOPEXIT:%.*]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
; UPPER-LABEL: @hoge_3(
; UPPER-NEXT:  entry:
; UPPER-NEXT:    [[X:%.*]] = load i32, ptr @global, align 4
; UPPER-NEXT:    [[Y:%.*]] = load ptr, ptr @global.1, align 4
; UPPER-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[X]], 17
; UPPER-NEXT:    br i1 [[TMP0]], label [[LOOP_PREHEADER:%.*]], label [[EXIT:%.*]]
; UPPER:       loop.preheader:
; UPPER-NEXT:    br label [[LOOP:%.*]]
; UPPER:       loop:
; UPPER-NEXT:    [[IV:%.*]] = phi i32 [ [[IV_NEXT:%.*]], [[LOOP]] ], [ [[X]], [[LOOP_PREHEADER]] ]
; UPPER-NEXT:    [[PTR:%.*]] = phi ptr [ [[PTR_NEXT:%.*]], [[LOOP]] ], [ [[Y]], [[LOOP_PREHEADER]] ]
; UPPER-NEXT:    [[IV_NEXT]] = add nuw i32 [[IV]], 8
; UPPER-NEXT:    [[PTR_NEXT]] = getelementptr inbounds i8, ptr [[PTR]], i32 1
; UPPER-NEXT:    store i8 [[ARG:%.*]], ptr [[PTR_NEXT]], align 1
; UPPER-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[IV_NEXT]], 17
; UPPER-NEXT:    br i1 [[TMP1]], label [[LOOP]], label [[EXIT_LOOPEXIT:%.*]]
; UPPER:       exit.loopexit:
; UPPER-NEXT:    br label [[EXIT]]
; UPPER:       exit:
; UPPER-NEXT:    ret void
;
entry:
  %x = load i32, ptr @global, align 4
  %y = load ptr, ptr @global.1, align 4
  %0 = icmp ult i32 %x, 17
  br i1 %0, label %loop, label %exit

loop:
  %iv = phi i32 [ %x, %entry ], [ %iv.next, %loop ]
  %ptr = phi ptr [ %y, %entry ], [ %ptr.next, %loop ]
  %iv.next = add nuw i32 %iv, 8
  %ptr.next = getelementptr inbounds i8, ptr %ptr, i32 1
  store i8 %arg, ptr %ptr.next, align 1
  %1 = icmp ult i32 %iv.next, 17
  br i1 %1, label %loop, label %exit

exit:
  ret void
}

; Check that loop in hoge_5, with a runtime upperbound of 5, is unrolled when -unroll-max-upperbound=4
define dso_local void @hoge_5(i8 %arg) {
; CHECK-LABEL: @hoge_5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr @global, align 4
; CHECK-NEXT:    [[Y:%.*]] = load ptr, ptr @global.1, align 4
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[X]], 17
; CHECK-NEXT:    br i1 [[TMP0]], label [[LOOP_PREHEADER:%.*]], label [[EXIT:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ [[IV_NEXT:%.*]], [[LOOP]] ], [ [[X]], [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[PTR:%.*]] = phi ptr [ [[PTR_NEXT:%.*]], [[LOOP]] ], [ [[Y]], [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i32 [[IV]], 4
; CHECK-NEXT:    [[PTR_NEXT]] = getelementptr inbounds i8, ptr [[PTR]], i32 1
; CHECK-NEXT:    store i8 [[ARG:%.*]], ptr [[PTR_NEXT]], align 1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[IV_NEXT]], 17
; CHECK-NEXT:    br i1 [[TMP1]], label [[LOOP]], label [[EXIT_LOOPEXIT:%.*]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
; UPPER-LABEL: @hoge_5(
; UPPER-NEXT:  entry:
; UPPER-NEXT:    [[X:%.*]] = load i32, ptr @global, align 4
; UPPER-NEXT:    [[Y:%.*]] = load ptr, ptr @global.1, align 4
; UPPER-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[X]], 17
; UPPER-NEXT:    br i1 [[TMP0]], label [[LOOP_PREHEADER:%.*]], label [[EXIT:%.*]]
; UPPER:       loop.preheader:
; UPPER-NEXT:    br label [[LOOP:%.*]]
; UPPER:       loop:
; UPPER-NEXT:    [[IV_NEXT:%.*]] = add nuw i32 [[X]], 4
; UPPER-NEXT:    [[PTR_NEXT:%.*]] = getelementptr inbounds i8, ptr [[Y]], i32 1
; UPPER-NEXT:    store i8 [[ARG:%.*]], ptr [[PTR_NEXT]], align 1
; UPPER-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[IV_NEXT]], 17
; UPPER-NEXT:    br i1 [[TMP1]], label [[LOOP_1:%.*]], label [[EXIT_LOOPEXIT:%.*]]
; UPPER:       loop.1:
; UPPER-NEXT:    [[IV_NEXT_1:%.*]] = add nuw i32 [[X]], 8
; UPPER-NEXT:    [[PTR_NEXT_1:%.*]] = getelementptr inbounds i8, ptr [[PTR_NEXT]], i32 1
; UPPER-NEXT:    store i8 [[ARG]], ptr [[PTR_NEXT_1]], align 1
; UPPER-NEXT:    [[TMP2:%.*]] = icmp ult i32 [[IV_NEXT_1]], 17
; UPPER-NEXT:    br i1 [[TMP2]], label [[LOOP_2:%.*]], label [[EXIT_LOOPEXIT]]
; UPPER:       loop.2:
; UPPER-NEXT:    [[IV_NEXT_2:%.*]] = add nuw i32 [[X]], 12
; UPPER-NEXT:    [[PTR_NEXT_2:%.*]] = getelementptr inbounds i8, ptr [[PTR_NEXT_1]], i32 1
; UPPER-NEXT:    store i8 [[ARG]], ptr [[PTR_NEXT_2]], align 1
; UPPER-NEXT:    [[TMP3:%.*]] = icmp ult i32 [[IV_NEXT_2]], 17
; UPPER-NEXT:    br i1 [[TMP3]], label [[LOOP_3:%.*]], label [[EXIT_LOOPEXIT]]
; UPPER:       loop.3:
; UPPER-NEXT:    [[IV_NEXT_3:%.*]] = add nuw i32 [[X]], 16
; UPPER-NEXT:    [[PTR_NEXT_3:%.*]] = getelementptr inbounds i8, ptr [[PTR_NEXT_2]], i32 1
; UPPER-NEXT:    store i8 [[ARG]], ptr [[PTR_NEXT_3]], align 1
; UPPER-NEXT:    [[TMP4:%.*]] = icmp ult i32 [[IV_NEXT_3]], 17
; UPPER-NEXT:    br i1 [[TMP4]], label [[LOOP_4:%.*]], label [[EXIT_LOOPEXIT]]
; UPPER:       loop.4:
; UPPER-NEXT:    [[PTR_NEXT_4:%.*]] = getelementptr inbounds i8, ptr [[PTR_NEXT_3]], i32 1
; UPPER-NEXT:    store i8 [[ARG]], ptr [[PTR_NEXT_4]], align 1
; UPPER-NEXT:    br i1 false, label [[LOOP_5:%.*]], label [[EXIT_LOOPEXIT]]
; UPPER:       loop.5:
; UPPER-NEXT:    [[PTR_NEXT_5:%.*]] = getelementptr inbounds i8, ptr [[PTR_NEXT_4]], i32 1
; UPPER-NEXT:    store i8 [[ARG]], ptr [[PTR_NEXT_5]], align 1
; UPPER-NEXT:    br label [[EXIT_LOOPEXIT]]
; UPPER:       exit.loopexit:
; UPPER-NEXT:    br label [[EXIT]]
; UPPER:       exit:
; UPPER-NEXT:    ret void
;
entry:
  %x = load i32, ptr @global, align 4
  %y = load ptr, ptr @global.1, align 4
  %0 = icmp ult i32 %x, 17
  br i1 %0, label %loop, label %exit

loop:
  %iv = phi i32 [ %x, %entry ], [ %iv.next, %loop ]
  %ptr = phi ptr [ %y, %entry ], [ %ptr.next, %loop ]
  %iv.next = add nuw i32 %iv, 4
  %ptr.next = getelementptr inbounds i8, ptr %ptr, i32 1
  store i8 %arg, ptr %ptr.next, align 1
  %1 = icmp ult i32 %iv.next, 17
  br i1 %1, label %loop, label %exit

exit:
  ret void
}
