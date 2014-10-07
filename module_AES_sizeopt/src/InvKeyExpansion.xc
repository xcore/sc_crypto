// Copyright (c) 2011-2014, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "AESincludes.h"

static unsigned M0(unsigned char x) {
    return T0InvTable[sBox[x]];
}

static unsigned M1(unsigned char x) {
    unsigned val = M0(x);
    return val << 8 | val >> 24;
}

static unsigned M2(unsigned char x) {
    unsigned val = M0(x);
    return val << 16 | val >> 16;
}

static unsigned M3(unsigned char x) {
    unsigned val = M0(x);
    return val << 24 | val >> 8;
}

#pragma unsafe arrays
void AESDecryptExpandKey(unsigned int key[], unsigned int w[]){
	AESEncryptExpandKey(key, w);
	
	for(int i = 4; i < Nb * Nr; i++){
		//InvMixColumn for each key except for the first and final round
		w[i] = M0((w[i] << 24) >> 24) ^ M1((w[i] << 16) >> 24) ^ M2((w[i] << 8) >> 24) ^ M3(w[i] >> 24);
	}
	return;
}
