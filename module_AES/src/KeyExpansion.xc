// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 * Author: Suleiman Abu Kharmeh
 * Date: 19/November/2008
 *
 * This the most performance optimised XC version.
 *	Further hand crafted optimisations are implemented in the assembly version
 * See KeyExpansion.S for more details.
 */

#include "AESincludes.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////
//the total number of Round Key bits is equal to the block length multiplied by the number of rounds plus1.
#pragma unsafe arrays
void AESEncryptExpandKey(unsigned int key[], unsigned int w[]){
	static const unsigned char rCon[11] = {
		0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36
	};

	w[0] = key[0];
	w[1] = key[1];
	w[2] = key[2];
	w[3] = key[3];

	#pragma loop unroll
	for(unsigned int t = 1; t < 11U; t++){//loop limit = Nb * (Nr + 1)
		unsigned int temp = w[t*4 - 1];
		//barrel shift
		temp = (temp >> 8) | (temp << 24);
		//sub word
		temp = sBox[(temp << 24) >> 24] ^ (sBox[(temp << 16) >> 24] << 8) ^ (sBox[(temp << 8) >> 24] << 16) ^ (sBox[temp >> 24] << 24);
		temp ^= rCon[t];
		
		w[t*4] = w[t*4 - 4] ^ temp;
		w[t*4 + 1] = w[t*4 - 3] ^ w[t*4];
		w[t*4 + 2] = w[t*4 - 2] ^ w[t*4 + 1];
		w[t*4 + 3] = w[t*4 - 1] ^ w[t*4 + 2];
	}
	return;
}
