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
extern unsigned int T0InvTable[256];

#endif
