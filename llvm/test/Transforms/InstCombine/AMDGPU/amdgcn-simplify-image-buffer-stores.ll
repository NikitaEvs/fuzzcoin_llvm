; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mcpu=gfx900 -S -passes=instcombine -mtriple=amdgcn-amd-amdhsa %s | FileCheck -check-prefixes=GCN %s
; RUN: opt -mcpu=gfx1010 -S -passes=instcombine -mtriple=amdgcn-amd-amdhsa %s | FileCheck -check-prefixes=GCN %s
; RUN: opt -mcpu=gfx1100 -S -passes=instcombine -mtriple=amdgcn-amd-amdhsa %s | FileCheck -check-prefixes=GCN %s

define amdgpu_ps void @image_store_1d_store_all_zeros(<8 x i32> inreg %rsrc, i32 %s) #0 {
; GCN-LABEL: @image_store_1d_store_all_zeros(
; GCN-NEXT:    call void @llvm.amdgcn.image.store.1d.f32.i32(float 0.000000e+00, i32 1, i32 [[S:%.*]], <8 x i32> [[RSRC:%.*]], i32 0, i32 0)
; GCN-NEXT:    ret void
;
  call void @llvm.amdgcn.image.store.1d.v4f32.i32(<4 x float> zeroinitializer, i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_1d_store_insert_zeros_at_end(<8 x i32> inreg %rsrc, float %vdata1, i32 %s) #0 {
; GCN-LABEL: @image_store_1d_store_insert_zeros_at_end(
; GCN-NEXT:    call void @llvm.amdgcn.image.store.1d.f32.i32(float [[VDATA1:%.*]], i32 1, i32 [[S:%.*]], <8 x i32> [[RSRC:%.*]], i32 0, i32 0)
; GCN-NEXT:    ret void
;
  %newvdata1 = insertelement <4 x float> undef, float %vdata1, i32 0
  %newvdata2 = insertelement <4 x float> %newvdata1, float 0.0, i32 1
  %newvdata3 = insertelement <4 x float> %newvdata2, float 0.0, i32 2
  %newvdata4 = insertelement <4 x float> %newvdata3, float 0.0, i32 3
  call void @llvm.amdgcn.image.store.1d.v4f32.i32(<4 x float> %newvdata4, i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_mip_1d_store_insert_zeros_at_end(<8 x i32> inreg %rsrc, float %vdata1, float %vdata2, i32 %s, i32 %mip) #0 {
; GCN-LABEL: @image_store_mip_1d_store_insert_zeros_at_end(
; GCN-NEXT:    [[TMP1:%.*]] = insertelement <3 x float> <float 0.000000e+00, float poison, float poison>, float [[VDATA1:%.*]], i64 1
; GCN-NEXT:    [[TMP2:%.*]] = insertelement <3 x float> [[TMP1]], float [[VDATA2:%.*]], i64 2
; GCN-NEXT:    call void @llvm.amdgcn.image.store.1d.v3f32.i32(<3 x float> [[TMP2]], i32 7, i32 [[S:%.*]], <8 x i32> [[RSRC:%.*]], i32 0, i32 0)
; GCN-NEXT:    ret void
;
  %newvdata1 = insertelement <4 x float> undef, float 0.0, i32 0
  %newvdata2 = insertelement <4 x float> %newvdata1, float %vdata1, i32 1
  %newvdata3 = insertelement <4 x float> %newvdata2, float %vdata2, i32 2
  %newvdata4 = insertelement <4 x float> %newvdata3, float 0.0, i32 3
  call void @llvm.amdgcn.image.store.mip.1d.v4f32.i32(<4 x float> %newvdata4, i32 7, i32 %s, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_format_insert_zeros_at_end(<4 x i32> inreg %a, float %vdata1, i32 %b) {
; GCN-LABEL: @buffer_store_format_insert_zeros_at_end(
; GCN-NEXT:    [[TMP1:%.*]] = insertelement <2 x float> undef, float [[VDATA1:%.*]], i64 0
; GCN-NEXT:    [[TMP2:%.*]] = shufflevector <2 x float> [[TMP1]], <2 x float> poison, <2 x i32> zeroinitializer
; GCN-NEXT:    call void @llvm.amdgcn.buffer.store.format.v2f32(<2 x float> [[TMP2]], <4 x i32> [[A:%.*]], i32 [[B:%.*]], i32 0, i1 false, i1 false)
; GCN-NEXT:    ret void
;
  %newvdata1 = insertelement <4 x float> undef, float %vdata1, i32 0
  %newvdata2 = insertelement <4 x float> %newvdata1, float %vdata1, i32 1
  %newvdata3 = insertelement <4 x float> %newvdata2, float 0.0, i32 2
  %newvdata4 = insertelement <4 x float> %newvdata3, float 0.0, i32 3
  call void @llvm.amdgcn.buffer.store.format.v4f32(<4 x float> %newvdata4, <4 x i32> %a, i32 %b, i32 0, i1 0, i1 0)
  ret void
}

define amdgpu_ps void @struct_buffer_store_format_insert_zeros(<4 x i32> inreg %a, float %vdata1, i32 %b) {
; GCN-LABEL: @struct_buffer_store_format_insert_zeros(
; GCN-NEXT:    [[TMP1:%.*]] = insertelement <3 x float> <float poison, float 0.000000e+00, float poison>, float [[VDATA1:%.*]], i64 0
; GCN-NEXT:    [[TMP2:%.*]] = insertelement <3 x float> [[TMP1]], float [[VDATA1]], i64 2
; GCN-NEXT:    call void @llvm.amdgcn.struct.buffer.store.format.v3f32(<3 x float> [[TMP2]], <4 x i32> [[A:%.*]], i32 [[B:%.*]], i32 0, i32 42, i32 0)
; GCN-NEXT:    ret void
;
  %newvdata1 = insertelement <4 x float> undef, float %vdata1, i32 0
  %newvdata2 = insertelement <4 x float> %newvdata1, float 0.0, i32 1
  %newvdata3 = insertelement <4 x float> %newvdata2, float %vdata1, i32 2
  %newvdata4 = insertelement <4 x float> %newvdata3, float 0.0, i32 3
  call void @llvm.amdgcn.struct.buffer.store.format.v4f32(<4 x float> %newvdata4, <4 x i32> %a, i32 %b, i32 0, i32 42, i32 0)
  ret void
}

define amdgpu_ps void @struct_tbuffer_store_insert_zeros_at_beginning(<4 x i32> inreg %a, float %vdata1, i32 %b) {
; GCN-LABEL: @struct_tbuffer_store_insert_zeros_at_beginning(
; GCN-NEXT:    [[NEWVDATA4:%.*]] = insertelement <4 x float> <float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float poison>, float [[VDATA1:%.*]], i64 3
; GCN-NEXT:    call void @llvm.amdgcn.struct.tbuffer.store.v4f32(<4 x float> [[NEWVDATA4]], <4 x i32> [[A:%.*]], i32 [[B:%.*]], i32 0, i32 42, i32 0, i32 15)
; GCN-NEXT:    ret void
;
  %newvdata1 = insertelement <4 x float> undef, float 0.0, i32 0
  %newvdata2 = insertelement <4 x float> %newvdata1, float 0.0, i32 1
  %newvdata3 = insertelement <4 x float> %newvdata2, float 0.0, i32 2
  %newvdata4 = insertelement <4 x float> %newvdata3, float %vdata1, i32 3
  call void @llvm.amdgcn.struct.tbuffer.store.v4f32(<4 x float> %newvdata4, <4 x i32> %a, i32 %b, i32 0, i32 42, i32 0, i32 15)
  ret void
}

define amdgpu_ps void @struct_tbuffer_store_insert_undefs(<4 x i32> inreg %a, float %vdata1, i32 %b) {
; GCN-LABEL: @struct_tbuffer_store_insert_undefs(
; GCN-NEXT:    [[TMP1:%.*]] = insertelement <2 x float> <float poison, float 1.000000e+00>, float [[VDATA1:%.*]], i64 0
; GCN-NEXT:    call void @llvm.amdgcn.struct.tbuffer.store.v2f32(<2 x float> [[TMP1]], <4 x i32> [[A:%.*]], i32 [[B:%.*]], i32 0, i32 42, i32 0, i32 15)
; GCN-NEXT:    ret void
;
  %newvdata1 = insertelement <4 x float> poison, float %vdata1, i32 0
  %newvdata2 = insertelement <4 x float> %newvdata1, float 1.0, i32 1
  call void @llvm.amdgcn.struct.tbuffer.store.v4f32(<4 x float> %newvdata2, <4 x i32> %a, i32 %b, i32 0, i32 42, i32 0, i32 15)
  ret void
}


declare void @llvm.amdgcn.raw.buffer.store.format.v4f32(<4 x float>, <4 x i32>, i32, i32, i32) #2
declare void @llvm.amdgcn.buffer.store.format.v4f32(<4 x float>, <4 x i32>, i32, i32, i1, i1) #1
declare void @llvm.amdgcn.struct.buffer.store.format.v4f32(<4 x float>, <4 x i32>, i32, i32, i32, i32) #2
declare void @llvm.amdgcn.struct.tbuffer.store.v4f32(<4 x float>, <4 x i32>, i32, i32, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.tbuffer.store.v4f32(<4 x float>, <4 x i32>, i32, i32, i32, i32) #0
declare void @llvm.amdgcn.tbuffer.store.v4f32(<4 x float>, <4 x i32>, i32, i32, i32, i32, i32, i32, i1, i1) #0
declare void @llvm.amdgcn.image.store.1d.v4f32.i32(<4 x float>, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.2d.v4f32.i32(<4 x float>, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.3d.v4f32.i32(<4 x float>, i32, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.cube.v4f32.i32(<4 x float>, i32, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.1darray.v4f32.i32(<4 x float>, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.2darray.v4f32.i32(<4 x float>, i32, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.2dmsaa.v4f32.i32(<4 x float>, i32, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.2darraymsaa.v4f32.i32(<4 x float>, i32, i32, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.mip.1d.v4f32.i32(<4 x float>, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.mip.2d.v4f32.i32(<4 x float>, i32, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.mip.3d.v4f32.i32(<4 x float>, i32, i32, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.mip.cube.v4f32.i32(<4 x float>, i32, i32, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.mip.1darray.v4f32.i32(<4 x float>, i32, i32, i32, i32, <8 x i32>, i32, i32) #0
declare void @llvm.amdgcn.image.store.mip.2darray.v4f32.i32(<4 x float>, i32, i32, i32, i32, i32, <8 x i32>, i32, i32) #0

attributes #0 = { nounwind }
attributes #1 = { nounwind writeonly }
attributes #2 = { nounwind }