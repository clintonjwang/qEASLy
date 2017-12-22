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

#include <stdio.h>
#define EXPORTING_qEASLy 1
#include "qEASLy.h"

static HMCRINSTANCE _mcr_inst = NULL;


#if defined( _MSC_VER) || defined(__BORLANDC__) || defined(__WATCOMC__) || defined(__LCC__) || defined(__MINGW64__)
#ifdef __LCC__
#undef EXTERN_C
#endif
#include <windows.h>

static char path_to_dll[_MAX_PATH];

BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, void *pv)
{
    if (dwReason == DLL_PROCESS_ATTACH)
    {
        if (GetModuleFileName(hInstance, path_to_dll, _MAX_PATH) == 0)
            return FALSE;
    }
    else if (dwReason == DLL_PROCESS_DETACH)
    {
    }
    return TRUE;
}
#endif
#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_qEASLy_C_API
#define LIB_qEASLy_C_API /* No special import/export declaration */
#endif

LIB_qEASLy_C_API 
bool MW_CALL_CONV qEASLyInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler)
{
    int bResult = 0;
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
  if (!GetModuleFileName(GetModuleHandle("qEASLy"), path_to_dll, _MAX_PATH))
    return false;
    {
        mclCtfStream ctfStream = 
            mclGetEmbeddedCtfStream(path_to_dll);
        if (ctfStream) {
            bResult = mclInitializeComponentInstanceEmbedded(   &_mcr_inst,
                                                                error_handler, 
                                                                print_handler,
                                                                ctfStream);
            mclDestroyStream(ctfStream);
        } else {
            bResult = 0;
        }
    }  
    if (!bResult)
    return false;
  return true;
}

LIB_qEASLy_C_API 
bool MW_CALL_CONV qEASLyInitialize(void)
{
  return qEASLyInitializeWithHandlers(mclDefaultErrorHandler, mclDefaultPrintHandler);
}

LIB_qEASLy_C_API 
void MW_CALL_CONV qEASLyTerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

LIB_qEASLy_C_API 
void MW_CALL_CONV qEASLyPrintStackTrace(void) 
{
  char** stackTrace;
  int stackDepth = mclGetStackTrace(&stackTrace);
  int i;
  for(i=0; i<stackDepth; i++)
  {
    mclWrite(2 /* stderr */, stackTrace[i], sizeof(char)*strlen(stackTrace[i]));
    mclWrite(2 /* stderr */, "\n", sizeof(char)*strlen("\n"));
  }
  mclFreeStackTrace(&stackTrace, stackDepth);
}


LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxFlip_image(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "flip_image", nlhs, plhs, nrhs, prhs);
}

LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxGet_enhance_vol(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "get_enhance_vol", nlhs, plhs, nrhs, prhs);
}

LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxQeasly_func(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "qeasly_func", nlhs, plhs, nrhs, prhs);
}

LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxQeaslyInterface(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "qeaslyInterface", nlhs, plhs, nrhs, prhs);
}

LIB_qEASLy_C_API 
bool MW_CALL_CONV mlxTranspose_mask_slices(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[])
{
  return mclFeval(_mcr_inst, "transpose_mask_slices", nlhs, plhs, nrhs, prhs);
}

LIB_qEASLy_CPP_API 
void MW_CALL_CONV flip_image(int nargout, mwArray& image_o, const mwArray& image)
{
  mclcppMlfFeval(_mcr_inst, "flip_image", nargout, 1, 1, &image_o, &image);
}

LIB_qEASLy_CPP_API 
void MW_CALL_CONV get_enhance_vol(int nargout, mwArray& tumor_vol, mwArray& 
                                  enhancing_vol, mwArray& enh_mask, mwArray& nec_mask, 
                                  const mwArray& pre, const mwArray& art, const mwArray& 
                                  tumor_mask, const mwArray& vox_dims, const mwArray& 
                                  intensity_mode, const mwArray& median_std)
{
  mclcppMlfFeval(_mcr_inst, "get_enhance_vol", nargout, 4, 6, &tumor_vol, &enhancing_vol, &enh_mask, &nec_mask, &pre, &art, &tumor_mask, &vox_dims, &intensity_mode, &median_std);
}

LIB_qEASLy_CPP_API 
void MW_CALL_CONV qeasly_func(int nargout, mwArray& roi_mode, mwArray& median_std, const 
                              mwArray& art, const mwArray& pre, const mwArray& liver_mask)
{
  mclcppMlfFeval(_mcr_inst, "qeasly_func", nargout, 2, 3, &roi_mode, &median_std, &art, &pre, &liver_mask);
}

LIB_qEASLy_CPP_API 
void MW_CALL_CONV qeaslyInterface(int nargout, mwArray& status, mwArray& message, 
                                  mwArray& outputVolumes, const mwArray& inputVolumes)
{
  mclcppMlfFeval(_mcr_inst, "qeaslyInterface", nargout, 3, 1, &status, &message, &outputVolumes, &inputVolumes);
}

LIB_qEASLy_CPP_API 
void MW_CALL_CONV transpose_mask_slices(int nargout, mwArray& out_mask, const mwArray& 
                                        mask, const mwArray& mode)
{
  mclcppMlfFeval(_mcr_inst, "transpose_mask_slices", nargout, 1, 2, &out_mask, &mask, &mode);
}

