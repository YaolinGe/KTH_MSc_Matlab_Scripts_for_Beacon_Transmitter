/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_test_out_api.h
 *
 * Code generation for function '_coder_test_out_api'
 *
 */

#ifndef _CODER_TEST_OUT_API_H
#define _CODER_TEST_OUT_API_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void test_out(real_T x[10], real_T y[10]);
extern void test_out_api(const mxArray * const prhs[1], int32_T nlhs, const
  mxArray *plhs[1]);
extern void test_out_atexit(void);
extern void test_out_initialize(void);
extern void test_out_terminate(void);
extern void test_out_xil_shutdown(void);
extern void test_out_xil_terminate(void);

#endif

/* End of code generation (_coder_test_out_api.h) */
