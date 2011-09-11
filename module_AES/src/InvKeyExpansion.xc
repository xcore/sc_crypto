// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 * Author: Suleiman Abu Kharmeh
 * Date: 19/November/2008
 *
 * This the most performance optimised XC version.
 * Further hand crafted optimisations are implemented in the assembly version
 * See InvKeyExpansion.S for more details.
 *
 */

#include "AESincludes.h"
#pragma unsafe arrays
void AESDecryptExpandKey(unsigned int key[], unsigned int w[]){
        int i;
	
	AESEncryptExpandKey(key, w);
	
	#pragma loop unroll
	for(i = 4; i < Nb * Nr; i++){
		//InvMixColumn for each key except for the first and final round
		w[i] = M0[(w[i] << 24) >> 24] ^ M1[(w[i] << 16) >> 24] ^ M2[(w[i] << 8) >> 24] ^ M3[w[i] >> 24];
	}
	return;
}
