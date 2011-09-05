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
 * See Encrypt.S for more details.
 */
#ifndef _ENCRYPT
#define _ENCRYPT

#include "AESincludes.h"
#pragma unsafe arrays
void AESEncryptBlock(unsigned int plainText[], unsigned int w[], unsigned int cipherText[]) {
	unsigned int laststate0, laststate1, laststate2, laststate3;
	unsigned int state0, state1, state2, state3;

	//init and initial add key
	state0 = plainText[0] ^ w[0];
	state1 = plainText[1] ^ w[1];
	state2 = plainText[2] ^ w[2];
	state3 = plainText[3] ^ w[3];
	
	//rounds 1 to 9
	#pragma loop unroll(9)
	for (int i = 1; i <= 9; i++) {
		laststate0 = state0;
		laststate1 = state1;
		laststate2 = state2;
		laststate3 = state3;
		
		state0 = T0[(laststate0 << 24) >> 24] ^ T1[(laststate1 << 16) >> 24] ^ T2[(laststate2 << 8) >> 24] ^ T3[laststate3 >> 24] ^ w[4*i];
		state1 = T0[(laststate1 << 24) >> 24] ^ T1[(laststate2 << 16) >> 24] ^ T2[(laststate3 << 8) >> 24] ^ T3[laststate0 >> 24] ^ w[4*i+1];
		state2 = T0[(laststate2 << 24) >> 24] ^ T1[(laststate3 << 16) >> 24] ^ T2[(laststate0 << 8) >> 24] ^ T3[laststate1 >> 24] ^ w[4*i+2];
		state3 = T0[(laststate3 << 24) >> 24] ^ T1[(laststate0 << 16) >> 24] ^ T2[(laststate1 << 8) >> 24] ^ T3[laststate2 >> 24] ^ w[4*i+3];
	}
	
	//round 10
	cipherText[0] = sBox[(state0 << 24) >> 24] ^ (sBox[(state1 << 16) >> 24] << 8) ^ (sBox[(state2 << 8) >> 24] << 16) ^ (sBox[state3 >> 24] << 24) ^ w[40];
	cipherText[1] = sBox[(state1 << 24) >> 24] ^ (sBox[(state2 << 16) >> 24] << 8) ^ (sBox[(state3 << 8) >> 24] << 16) ^ (sBox[state0 >> 24] << 24) ^ w[41];
	cipherText[2] = sBox[(state2 << 24) >> 24] ^ (sBox[(state3 << 16) >> 24] << 8) ^ (sBox[(state0 << 8) >> 24] << 16) ^ (sBox[state1 >> 24] << 24) ^ w[42];
	cipherText[3] = sBox[(state3 << 24) >> 24] ^ (sBox[(state0 << 16) >> 24] << 8) ^ (sBox[(state1 << 8) >> 24] << 16) ^ (sBox[state2 >> 24] << 24) ^ w[43];
	
	return;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma unsafe arrays
void AESEncrypt(unsigned int plainText[], unsigned int key[], unsigned int cipherText[]){
	
	unsigned int w[Nb * (Nr + 1)];
	
	AESEncryptExpandKey(key, w);
	
	AESEncryptBlock(plainText, w, cipherText);
	
}
#endif

