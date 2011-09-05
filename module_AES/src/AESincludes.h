// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 * Author: Suleiman Abu Kharmeh
 * Date: 19/November/2008
 *
 *	This API only supports 128 bit block.
 *	It can be extended to support other block sizes 
 *
 */
#ifndef AESincludes_h

#define AESincludes_h

#include "AESfunctions.h"

extern unsigned char sBox[256];
extern unsigned char sBoxInv[256];
extern unsigned char rCon[11];
extern unsigned int T0[256];
extern unsigned int T1[256];
extern unsigned int T2[256];
extern unsigned int T3[256];
extern unsigned int T0Inv[256];
extern unsigned int T1Inv[256];
extern unsigned int T2Inv[256];
extern unsigned int T3Inv[256];
extern unsigned int M0[256];
extern unsigned int M1[256];
extern unsigned int M2[256];
extern unsigned int M3[256];

#endif
