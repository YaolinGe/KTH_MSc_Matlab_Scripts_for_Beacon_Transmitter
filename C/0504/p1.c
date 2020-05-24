/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * test_out.c
 *
 * Code generation for function 'test_out'
 *
 */

/* Include files */
#include "test_out.h"
#include "rt_nonfinite.h"
#include "test_out_data.h"
#include "test_out_initialize.h"
#include <math.h>
#include <string.h>

/* Function Definitions */
void test_out(const double x[10], double y[10])
{
  int k;
  double miny;
  double delta2;
  double delta1;
  double edges[11];
  double nn[11];
  int xind;
  int exitg1;
  int low_i;
  int low_ip1;
  int high_i;
  int mid_i;
  if (isInitialized_test_out == false) {
    test_out_initialize();
  }

  k = 0;
  while ((k + 1 <= 10) && (rtIsInf(x[k]) || rtIsNaN(x[k]))) {
    k++;
  }

  if (k + 1 > 10) {
    miny = 0.0;
    delta2 = 0.0;
  } else {
    miny = x[k];
    delta2 = x[k];
    while (k + 1 <= 10) {
      if ((!rtIsInf(x[k])) && (!rtIsNaN(x[k]))) {
        if (x[k] < miny) {
          miny = x[k];
        }

        if (x[k] > delta2) {
          delta2 = x[k];
        }
      }

      k++;
    }
  }

  if (miny == delta2) {
    miny = (miny - 5.0) - 0.5;
    delta2 = (delta2 + 5.0) - 0.5;
  }

  if (miny == -delta2) {
    for (k = 0; k < 9; k++) {
      edges[k + 1] = delta2 * ((2.0 * ((double)k + 2.0) - 12.0) / 10.0);
    }

    edges[5] = 0.0;
  } else if (((miny < 0.0) != (delta2 < 0.0)) && ((fabs(miny) >
               8.9884656743115785E+307) || (fabs(delta2) >
               8.9884656743115785E+307))) {
    delta1 = miny / 10.0;
    delta2 /= 10.0;
    for (k = 0; k < 9; k++) {
      edges[k + 1] = (miny + delta2 * ((double)k + 1.0)) - delta1 * ((double)k +
        1.0);
    }
  } else {
    delta1 = (delta2 - miny) / 10.0;
    for (k = 0; k < 9; k++) {
      edges[k + 1] = miny + ((double)k + 1.0) * delta1;
    }
  }

  edges[0] = rtMinusInf;
  edges[10] = rtInf;
  for (k = 0; k < 9; k++) {
    miny = edges[k + 1];
    delta2 = fabs(miny);
    if ((!rtIsInf(delta2)) && (!rtIsNaN(delta2))) {
      if (delta2 <= 2.2250738585072014E-308) {
        delta2 = 4.94065645841247E-324;
      } else {
        frexp(delta2, &xind);
        delta2 = ldexp(1.0, xind - 53);
      }
    } else {
      delta2 = rtNaN;
    }

    edges[k + 1] = miny + delta2;
  }

  memset(&nn[0], 0, 11U * sizeof(double));
  xind = 1;
  do {
    exitg1 = 0;
    if (xind + 1 < 12) {
      if (!(edges[xind] >= edges[xind - 1])) {
        for (xind = 0; xind < 11; xind++) {
          nn[xind] = rtNaN;
        }

        exitg1 = 1;
      } else {
        xind++;
      }
    } else {
      xind = 0;
      for (k = 0; k < 10; k++) {
        low_i = 0;
        if (!rtIsNaN(x[xind])) {
          if ((x[xind] >= edges[0]) && (x[xind] < edges[10])) {
            low_i = 1;
            low_ip1 = 2;
            high_i = 11;
            while (high_i > low_ip1) {
              mid_i = (low_i + high_i) >> 1;
              if (x[xind] >= edges[mid_i - 1]) {
                low_i = mid_i;
                low_ip1 = mid_i + 1;
              } else {
                high_i = mid_i;
              }
            }
          }

          if (x[xind] == edges[10]) {
            low_i = 11;
          }
        }

        if (low_i > 0) {
          nn[low_i - 1]++;
        }

        xind++;
      }

      exitg1 = 1;
    }
  } while (exitg1 == 0);

  memcpy(&y[0], &nn[0], 10U * sizeof(double));
  y[9] += nn[10];
}

/* End of code generation (test_out.c) */
