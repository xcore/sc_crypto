// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 * Author: Suleiman Abu Kharmeh
 * Date: 19/November/2008
 *
 * This is the most performance optimised XC version.
 * Further hand crafted optimisations are implemented in the assembly version
 * See Decrypt.S for more details.
 */

#include "AESincludes.h"
#include "AESConfig.h"

#ifndef AES_USE_ASSEMBLY
#pragma unsafe arrays
void AESDecryptBlock(unsigned int cipherText[], unsigned int dw[], unsigned int decryptedText[]) {
	unsigned int laststate0, laststate1, laststate2, laststate3;
	unsigned int state0, state1, state2, state3;

	// initialize and initial add round key
	state0 = cipherText[0] ^ dw[40];
	state1 = cipherText[1] ^ dw[41];
	state2 = cipherText[2] ^ dw[42];
	state3 = cipherText[3] ^ dw[43];

	// rounds 10 to 2
	#pragma loop unroll
	for (unsigned i = 10; i >= 2; i--) {
		laststate0 = state0;
		laststate1 = state1;
		laststate2 = state2;
		laststate3 = state3;

		state0 = T0Inv[(laststate0 << 24) >> 24] ^ T1Inv[(laststate3 << 16) >> 24] ^ T2Inv[(laststate2 << 8) >> 24] ^ T3Inv[laststate1 >> 24] ^ dw[4*i-4];
		state1 = T0Inv[(laststate1 << 24) >> 24] ^ T1Inv[(laststate0 << 16) >> 24] ^ T2Inv[(laststate3 << 8) >> 24] ^ T3Inv[laststate2 >> 24] ^ dw[4*i-3];
		state2 = T0Inv[(laststate2 << 24) >> 24] ^ T1Inv[(laststate1 << 16) >> 24] ^ T2Inv[(laststate0 << 8) >> 24] ^ T3Inv[laststate3 >> 24] ^ dw[4*i-2];
		state3 = T0Inv[(laststate3 << 24) >> 24] ^ T1Inv[(laststate2 << 16) >> 24] ^ T2Inv[(laststate1 << 8) >> 24] ^ T3Inv[laststate0 >> 24] ^ dw[4*i-1];
	}
	// round 1
	decryptedText[0] = sBoxInv[(state0 << 24) >> 24] ^ (sBoxInv[(state3 << 16) >> 24] << 8) ^ (sBoxInv[(state2 << 8) >> 24] << 16) ^ (sBoxInv[state1 >> 24] << 24) ^ dw[0];
	decryptedText[1] = sBoxInv[(state1 << 24) >> 24] ^ (sBoxInv[(state0 << 16) >> 24] << 8) ^ (sBoxInv[(state3 << 8) >> 24] << 16) ^ (sBoxInv[state2 >> 24] << 24) ^ dw[1];
	decryptedText[2] = sBoxInv[(state2 << 24) >> 24] ^ (sBoxInv[(state1 << 16) >> 24] << 8) ^ (sBoxInv[(state0 << 8) >> 24] << 16) ^ (sBoxInv[state3 >> 24] << 24) ^ dw[2];
	decryptedText[3] = sBoxInv[(state3 << 24) >> 24] ^ (sBoxInv[(state2 << 16) >> 24] << 8) ^ (sBoxInv[(state1 << 8) >> 24] << 16) ^ (sBoxInv[state0 >> 24] << 24) ^ dw[3];
	return;
}
#endif //AES_USE_ASSEMBLY

void AESDecrypt(unsigned int cipherText[], unsigned int key[], unsigned int decryptedText[]){
	unsigned int w[Nb * (Nr + 1)];
	
	AESDecryptExpandKey(key, w);
	AESDecryptBlock(cipherText, w, decryptedText);
}
