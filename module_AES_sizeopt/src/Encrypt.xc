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

static unsigned int T0Table[256] = {
    0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6, 0x0df2f2ff, 0xbd6b6bd6, 0xb16f6fde, 0x54c5c591, 0x50303060, 0x03010102, 0xa96767ce, 0x7d2b2b56, 0x19fefee7, 0x62d7d7b5, 0xe6abab4d, 0x9a7676ec,
    0x45caca8f, 0x9d82821f, 0x40c9c989, 0x877d7dfa, 0x15fafaef, 0xeb5959b2, 0xc947478e, 0x0bf0f0fb, 0xecadad41, 0x67d4d4b3, 0xfda2a25f, 0xeaafaf45, 0xbf9c9c23, 0xf7a4a453, 0x967272e4, 0x5bc0c09b,
    0xc2b7b775, 0x1cfdfde1, 0xae93933d, 0x6a26264c, 0x5a36366c, 0x413f3f7e, 0x02f7f7f5, 0x4fcccc83, 0x5c343468, 0xf4a5a551, 0x34e5e5d1, 0x08f1f1f9, 0x937171e2, 0x73d8d8ab, 0x53313162, 0x3f15152a,
    0x0c040408, 0x52c7c795, 0x65232346, 0x5ec3c39d, 0x28181830, 0xa1969637, 0x0f05050a, 0xb59a9a2f, 0x0907070e, 0x36121224, 0x9b80801b, 0x3de2e2df, 0x26ebebcd, 0x6927274e, 0xcdb2b27f, 0x9f7575ea,
    0x1b090912, 0x9e83831d, 0x742c2c58, 0x2e1a1a34, 0x2d1b1b36, 0xb26e6edc, 0xee5a5ab4, 0xfba0a05b, 0xf65252a4, 0x4d3b3b76, 0x61d6d6b7, 0xceb3b37d, 0x7b292952, 0x3ee3e3dd, 0x712f2f5e, 0x97848413,
    0xf55353a6, 0x68d1d1b9, 0x00000000, 0x2cededc1, 0x60202040, 0x1ffcfce3, 0xc8b1b179, 0xed5b5bb6, 0xbe6a6ad4, 0x46cbcb8d, 0xd9bebe67, 0x4b393972, 0xde4a4a94, 0xd44c4c98, 0xe85858b0, 0x4acfcf85,
    0x6bd0d0bb, 0x2aefefc5, 0xe5aaaa4f, 0x16fbfbed, 0xc5434386, 0xd74d4d9a, 0x55333366, 0x94858511, 0xcf45458a, 0x10f9f9e9, 0x06020204, 0x817f7ffe, 0xf05050a0, 0x443c3c78, 0xba9f9f25, 0xe3a8a84b,
    0xf35151a2, 0xfea3a35d, 0xc0404080, 0x8a8f8f05, 0xad92923f, 0xbc9d9d21, 0x48383870, 0x04f5f5f1, 0xdfbcbc63, 0xc1b6b677, 0x75dadaaf, 0x63212142, 0x30101020, 0x1affffe5, 0x0ef3f3fd, 0x6dd2d2bf,
    0x4ccdcd81, 0x140c0c18, 0x35131326, 0x2fececc3, 0xe15f5fbe, 0xa2979735, 0xcc444488, 0x3917172e, 0x57c4c493, 0xf2a7a755, 0x827e7efc, 0x473d3d7a, 0xac6464c8, 0xe75d5dba, 0x2b191932, 0x957373e6,
    0xa06060c0, 0x98818119, 0xd14f4f9e, 0x7fdcdca3, 0x66222244, 0x7e2a2a54, 0xab90903b, 0x8388880b, 0xca46468c, 0x29eeeec7, 0xd3b8b86b, 0x3c141428, 0x79dedea7, 0xe25e5ebc, 0x1d0b0b16, 0x76dbdbad,
    0x3be0e0db, 0x56323264, 0x4e3a3a74, 0x1e0a0a14, 0xdb494992, 0x0a06060c, 0x6c242448, 0xe45c5cb8, 0x5dc2c29f, 0x6ed3d3bd, 0xefacac43, 0xa66262c4, 0xa8919139, 0xa4959531, 0x37e4e4d3, 0x8b7979f2,
    0x32e7e7d5, 0x43c8c88b, 0x5937376e, 0xb76d6dda, 0x8c8d8d01, 0x64d5d5b1, 0xd24e4e9c, 0xe0a9a949, 0xb46c6cd8, 0xfa5656ac, 0x07f4f4f3, 0x25eaeacf, 0xaf6565ca, 0x8e7a7af4, 0xe9aeae47, 0x18080810,
    0xd5baba6f, 0x887878f0, 0x6f25254a, 0x722e2e5c, 0x241c1c38, 0xf1a6a657, 0xc7b4b473, 0x51c6c697, 0x23e8e8cb, 0x7cdddda1, 0x9c7474e8, 0x211f1f3e, 0xdd4b4b96, 0xdcbdbd61, 0x868b8b0d, 0x858a8a0f,
    0x907070e0, 0x423e3e7c, 0xc4b5b571, 0xaa6666cc, 0xd8484890, 0x05030306, 0x01f6f6f7, 0x120e0e1c, 0xa36161c2, 0x5f35356a, 0xf95757ae, 0xd0b9b969, 0x91868617, 0x58c1c199, 0x271d1d3a, 0xb99e9e27,
    0x38e1e1d9, 0x13f8f8eb, 0xb398982b, 0x33111122, 0xbb6969d2, 0x70d9d9a9, 0x898e8e07, 0xa7949433, 0xb69b9b2d, 0x221e1e3c, 0x92878715, 0x20e9e9c9, 0x49cece87, 0xff5555aa, 0x78282850, 0x7adfdfa5,
    0x8f8c8c03, 0xf8a1a159, 0x80898909, 0x170d0d1a, 0xdabfbf65, 0x31e6e6d7, 0xc6424284, 0xb86868d0, 0xc3414182, 0xb0999929, 0x772d2d5a, 0x110f0f1e, 0xcbb0b07b, 0xfc5454a8, 0xd6bbbb6d, 0x3a16162c
};

static unsigned T0(unsigned char x) {
    return T0Table[x];
}

static unsigned T1(unsigned char x) {
    unsigned val = T0(x);
    return val << 8 | val >> 24;
}

static unsigned T2(unsigned char x) {
    unsigned val = T0(x);
    return val << 16 | val >> 16;
}

static unsigned T3(unsigned char x) {
    unsigned val = T0(x);
    return val << 24 | val >> 8;
}

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
	for (int i = 1; i <= 9; i++) {
		laststate0 = state0;
		laststate1 = state1;
		laststate2 = state2;
		laststate3 = state3;
		
		state0 = T0((laststate0 << 24) >> 24) ^ T1((laststate1 << 16) >> 24) ^ T2((laststate2 << 8) >> 24) ^ T3(laststate3 >> 24) ^ w[4*i];
		state1 = T0((laststate1 << 24) >> 24) ^ T1((laststate2 << 16) >> 24) ^ T2((laststate3 << 8) >> 24) ^ T3(laststate0 >> 24) ^ w[4*i+1];
		state2 = T0((laststate2 << 24) >> 24) ^ T1((laststate3 << 16) >> 24) ^ T2((laststate0 << 8) >> 24) ^ T3(laststate1 >> 24) ^ w[4*i+2];
		state3 = T0((laststate3 << 24) >> 24) ^ T1((laststate0 << 16) >> 24) ^ T2((laststate1 << 8) >> 24) ^ T3(laststate2 >> 24) ^ w[4*i+3];
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
