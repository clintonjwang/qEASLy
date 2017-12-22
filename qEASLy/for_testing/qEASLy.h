//
// MATLAB Compiler: 6.4 (R2017a)
// Date: Thu Dec 21 18:21:38 2017
// Arguments:
// "-B""macro_default""-W""cpplib:qEASLy""-T""link:lib""-d""C:\Users\Clinton\Doc
// uments\MATLAB\qEASLy\qEASLy\for_testing""-v""C:\Users\Clinton\Documents\MATLA
// B\qEASLy\flip_image.m""C:\Users\Clinton\Documents\MATLAB\qEASLy\get_enhance_v
// ol.m""C:\Users\Clinton\Documents\MATLAB\qEASLy\qeasly_func.m""C:\Users\Clinto
// n\Documents\MATLAB\qEASLy\qeaslyInterface.m""C:\Users\Clinton\Documents\MATLA
// B\qEASLy\transpose_mask_slices.m"
//

#ifndef __qEASLy_h
#define __qEASLy_h 1

#if defined(__cplusplus) && !defined(mclmcrrt_h) && defined(__linux__)
#  pragma implementation "mclmcrrt.h"
#endif
#include "mclmcrrt.h"
#include "mclcppclass.h"
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__SUNPRO_CC)
/* Solaris shared libraries use __global, rather than mapfiles
 * to define the API exported from a shared library. __global is
 * only necessary when building the library -- files including
 * this header file to use the library do not need the __global
 * declaration; hence the EXPORTING_<library> logic.
 */

#ifdef EXPORTING_qEASLy
#define PUBLIC_qEASLy_C_API __global
#else
#define PUBLIC_qEASLy_C_API /* No import statement needed. */
#endif

#define LIB_qEASLy_C_API PUBLIC_qEASLy_C_API

#elif defined(_HPUX_SOURCE)

#ifdef EXPORTING_qEASLy
#define PUBLIC_qEASLy_C_API __declspec(dllexport)
#else
#define PUBLIC_qEASLy_C_API __declspec(dllimport)
#endif

#define LIB_qEASLy_C_API PUBLIC_qEASLy_C_API


#else

#define LIB_qEASLy_C_API

#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_qEASLy_C_API 
#define LIB_qEASLy_C_API /* No special import/export declaration */
#endif

extern LIB_qEASLy_C_API 
bool MW_CALL_CONV qEASLyInitializeWithHandlers(
       mclOutputHandlerFcn error_handler, 
       mclOutputHandlerFcn print_handler);

extern LIB_qEASLy_C_API 
bool MW_CALL_CONV qEASLyInitialize(void);

extern LIB_qEASLy_C_API 
void MW_CALL_CONV qEASLyTerminate(void);



extern LIB_qEASLy_C_API 
void MW_CALL_CONV qEASLyPrintStackTrace(void);

extern LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxFlip_image(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxGet_enhance_vol(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                     *prhs[]);

extern LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxQeasly_func(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxQeaslyInterface(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                     *prhs[]);

extern LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxTranspose_mask_slices(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[]);


#ifdef __cplusplus
}
#endif

#ifdef __cplusplus

/* On Windows, use __declspec to control the exported API */
#if defined(_MSC_VER) || defined(__BORLANDC__)

#ifdef EXPORTING_qEASLy
#define PUBLIC_qEASLy_CPP_API __declspec(dllexport)
#else
#define PUBLIC_qEASLy_CPP_API __declspec(dllimport)
#endif

#define LIB_qEASLy_CPP_API PUBLIC_qEASLy_CPP_API

#else

#if !defined(LIB_qEASLy_CPP_API)
#if defined(LIB_qEASLy_C_API)
#define LIB_qEASLy_CPP_API LIB_qEASLy_C_API
#else
#define LIB_qEASLy_CPP_API /* empty! */ 
#endif
#endif

#endif

extern LIB_qEASLy_CPP_API void MW_CALL_CONV flip_image(int nargout, mwArray& image_o, const mwArray& image);

extern LIB_qEASLy_CPP_API void MW_CALL_CONV get_enhance_vol(int nargout, mwArray& tumor_vol, mwArray& enhancing_vol, mwArray& enh_mask, mwArray& nec_mask, const mwArray& pre, const mwArray& art, const mwArray& tumor_mask, const mwArray& vox_dims, const mwArray& intensity_mode, const mwArray& median_std);

extern LIB_qEASLy_CPP_API void MW_CALL_CONV qeasly_func(int nargout, mwArray& roi_mode, mwArray& median_std, const mwArray& art, const mwArray& pre, const mwArray& liver_mask);

extern LIB_qEASLy_CPP_API void MW_CALL_CONV qeaslyInterface(int nargout, mwArray& status, mwArray& message, mwArray& outputVolumes, const mwArray& inputVolumes);

extern LIB_qEASLy_CPP_API void MW_CALL_CONV transpose_mask_slices(int nargout, mwArray& out_mask, const mwArray& mask, const mwArray& mode);

#endif
#endif
