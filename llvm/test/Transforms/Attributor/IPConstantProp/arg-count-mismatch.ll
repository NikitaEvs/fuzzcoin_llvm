; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-annotate-decl-cs  -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC

; The original C source looked like this:
;
;   long long a101, b101, e101;
;   volatile long c101;
;   int d101;
;
;   static inline int bar(p1, p2)
;   {
;       return 0;
;   }
;
;   void foo(unsigned p1)
;   {
;       long long *f = &b101, *g = &e101;
;       c101 = 0;
;       (void)((*f |= a101) - (*g = bar(d101)));
;       c101 = (*f |= a101 &= p1) == d101;
;   }
;
; When compiled with Clang it gives a warning
;   warning: too few arguments in call to 'bar'
;
; This ll reproducer has been reduced to only include tha call.
;
; Note that -lint will report this as UB, but it passes -verify.

; This test is just to verify that we do not crash/assert due to mismatch in
; argument count between the caller and callee.

; FIXME we should recognize this as UB and make it an unreachable.

define dso_local i16 @foo(i16 %a) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@foo
; TUNIT-SAME: (i16 [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; TUNIT-NEXT:    ret i16 0
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@foo
; CGSCC-SAME: (i16 [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; CGSCC-NEXT:    [[CALL:%.*]] = call noundef i16 @bar(i16 [[A]]) #[[ATTR2:[0-9]+]]
; CGSCC-NEXT:    ret i16 [[CALL]]
;
  %call = call i16 @bar(i16 %a)
  ret i16 %call
}

define internal i16 @bar(i16 %p1, i16 %p2) {
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@bar
; CGSCC-SAME: (i16 [[P1:%.*]], i16 [[P2:%.*]]) #[[ATTR1:[0-9]+]] {
; CGSCC-NEXT:    ret i16 0
;
  ret i16 0
}

define dso_local i16 @foo2(i16 %a) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@foo2
; TUNIT-SAME: (i16 [[A:%.*]]) #[[ATTR0]] {
; TUNIT-NEXT:    [[CALL:%.*]] = call i16 @bar2(i16 [[A]]) #[[ATTR1:[0-9]+]]
; TUNIT-NEXT:    ret i16 [[CALL]]
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@foo2
; CGSCC-SAME: (i16 [[A:%.*]]) #[[ATTR0]] {
; CGSCC-NEXT:    [[CALL:%.*]] = call i16 @bar2(i16 [[A]]) #[[ATTR2]]
; CGSCC-NEXT:    ret i16 [[CALL]]
;
  %call = call i16 @bar2(i16 %a)
  ret i16 %call
}

define internal i16 @bar2(i16 %p1, i16 %p2) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@bar2
; TUNIT-SAME: (i16 [[P1:%.*]], i16 [[P2:%.*]]) #[[ATTR0]] {
; TUNIT-NEXT:    [[A:%.*]] = add i16 [[P1]], [[P2]]
; TUNIT-NEXT:    ret i16 [[A]]
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@bar2
; CGSCC-SAME: (i16 [[P1:%.*]], i16 [[P2:%.*]]) #[[ATTR1]] {
; CGSCC-NEXT:    [[A:%.*]] = add i16 [[P1]], [[P2]]
; CGSCC-NEXT:    ret i16 [[A]]
;
  %a = add i16 %p1, %p2
  ret i16 %a
}


;-------------------------------------------------------------------------------
; Additional tests to verify that we still optimize when having a mismatch
; in argument count due to varargs (as long as all non-variadic arguments have
; been provided),

define dso_local i16 @vararg_tests(i16 %a) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@vararg_tests
; TUNIT-SAME: (i16 [[A:%.*]]) #[[ATTR0]] {
; TUNIT-NEXT:    ret i16 14
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@vararg_tests
; CGSCC-SAME: (i16 [[A:%.*]]) #[[ATTR0]] {
; CGSCC-NEXT:    [[CALL1:%.*]] = call i16 (i16, ...) @vararg_prop(i16 noundef 7, i16 noundef 8, i16 [[A]]) #[[ATTR2]]
; CGSCC-NEXT:    [[CALL2:%.*]] = call i16 @vararg_no_prop(i16 noundef 7) #[[ATTR2]]
; CGSCC-NEXT:    [[ADD:%.*]] = add i16 [[CALL1]], [[CALL2]]
; CGSCC-NEXT:    ret i16 [[ADD]]
;
  %call1 = call i16 (i16, ...) @vararg_prop(i16 7, i16 8, i16 %a)
  %call2 = call i16 @vararg_no_prop (i16 7)
  %add = add i16 %call1, %call2
  ret i16 %add
}

define internal i16 @vararg_prop(i16 %p1, ...) {
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@vararg_prop
; CGSCC-SAME: (i16 [[P1:%.*]], ...) #[[ATTR1]] {
; CGSCC-NEXT:    ret i16 7
;
  ret i16 %p1
}

define internal i16 @vararg_no_prop(i16 %p1, i16 %p2, ...) {
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@vararg_no_prop
; CGSCC-SAME: (i16 [[P1:%.*]], i16 [[P2:%.*]], ...) #[[ATTR1]] {
; CGSCC-NEXT:    ret i16 7
;
  ret i16 %p1
}

;.
; TUNIT: attributes #[[ATTR0]] = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
; TUNIT: attributes #[[ATTR1]] = { nofree nosync nounwind willreturn memory(none) }
;.
; CGSCC: attributes #[[ATTR0]] = { mustprogress nofree nosync nounwind willreturn memory(none) }
; CGSCC: attributes #[[ATTR1]] = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
; CGSCC: attributes #[[ATTR2]] = { nofree willreturn }
;.
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; CHECK: {{.*}}
