/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * test_out_initialize.c
 *
 * Code generation for function 'test_out_initialize'
 *
 */

/* Include files */
#include "test_out_initialize.h"
#include "rt_nonfinite.h"
#include "test_out.h"
#include "test_out_data.h"

/* Function Definitions */
void test_out_initialize(void)
{
  rt_InitInfAndNaN();
  isInitialized_test_out = true;
}

/* End of code generation (test_out_initialize.c) */
