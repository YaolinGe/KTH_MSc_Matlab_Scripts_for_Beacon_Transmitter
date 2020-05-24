/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_test_out_mex.c
 *
 * Code generation for function '_coder_test_out_mex'
 *
 */

/* Include files */
#include "_coder_test_out_mex.h"
#include "_coder_test_out_api.h"

/* Function Declarations */
MEXFUNCTION_LINKAGE void test_out_mexFunction(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[1]);

/* Function Definitions */
void test_out_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T nrhs, const
  mxArray *prhs[1])
{
  const mxArray *outputs[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 1, 4, 8,
                        "test_out");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 8,
                        "test_out");
  }

  /* Call the function. */
  test_out_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(test_out_atexit);

  /* Module initialization. */
  test_out_initialize();

  /* Dispatch the entry-point. */
  test_out_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  test_out_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_test_out_mex.c) */
