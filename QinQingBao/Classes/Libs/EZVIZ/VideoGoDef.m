//
//  VedioGoDef.m
//  VideoGo
//
//  Created by Dengsh on 13-1-10.
//
//

#import "VideoGoDef.h"

float gfStatusBarHeight = 20.0f;
float gfMainToolBarHeight = 50.0f;
float gfNavigationBarHeight = 44.0f;
int   giErrorCode = 0;
FILE * fLog = NULL;
FILE * fDebug = NULL;
FILE * fFile = NULL;
FILE * fFile2 = NULL;  
int   iSuccess = 0;
int   iFailed = 0;
long  lSeq = 0;

/******************************************/

long g_lRealTotleFlux       = 0;
long g_lRealBackFlux        = 0;
long g_lStreamDataTipRate   = 0;
BOOL g_bPswInputShow        = NO;
BOOL g_bShowListView        = NO;
long g_lLastSystemError     = 0;
/******************************************/


#ifdef DEBUG  
id g_playTypeHandle = nil;
#endif  
